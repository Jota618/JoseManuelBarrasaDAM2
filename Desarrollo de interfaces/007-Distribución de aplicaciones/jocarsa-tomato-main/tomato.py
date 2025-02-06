import matplotlib.pyplot as plt
import psutil
import time
import os
from datetime import datetime, timedelta

# Rutas locales en XAMPP para Windows
base_path = "C:/xampp/htdocs/tomato"
data_paths = {
    "hourly": os.path.join(base_path, "carga_hourly.txt"),
}
plot_folders = {
    "hourly": os.path.join(base_path, "img/hourly"),
}

# Crear las carpetas si no existen
for folder in plot_folders.values():
    os.makedirs(folder, exist_ok=True)

# Función para recortar datos antiguos (última hora)
def trim_data(data, time_window_seconds):
    now = datetime.now()
    return [entry for entry in data if (now - entry[0]).total_seconds() <= time_window_seconds]

# Cargar datos existentes
def load_data(file_path):
    try:
        with open(file_path, 'r') as f:
            return [
                (datetime.fromisoformat(row[0]), *map(float, row[1:]))
                for row in (line.strip().split(',') for line in f if line.strip())
            ]
    except FileNotFoundError:
        return []

# Guardar datos en archivo
def save_data(file_path, data):
    with open(file_path, 'w') as f:
        for row in data:
            f.write(','.join(map(str, [row[0].isoformat()] + list(row[1:]))) + '\n')

# Medir métricas del sistema
def measure_metrics():
    carga_cpu = psutil.cpu_percent(interval=1)
    carga_ram = psutil.virtual_memory().percent
    uso_disco = psutil.disk_usage('/').percent
    data_inicio = psutil.net_io_counters()
    time.sleep(1)
    data_final = psutil.net_io_counters()
    descarga_mbps = (data_final.bytes_recv - data_inicio.bytes_recv) / (1024 * 1024)
    subida_mbps = (data_final.bytes_sent - data_inicio.bytes_sent) / (1024 * 1024)
    num_conexiones = len(psutil.net_connections())
    temperatura_promedio = 45  # Valor ficticio, ya que no podemos leer temperaturas en Windows sin librerías adicionales
    return (
        datetime.now(),
        carga_cpu,
        carga_ram,
        uso_disco,
        descarga_mbps,
        subida_mbps,
        temperatura_promedio,
        num_conexiones,
    )

# Cargar datos actuales
data_buffers = {key: load_data(path) for key, path in data_paths.items()}

# Medir nuevas métricas
new_entry = measure_metrics()

# Actualizar buffer de datos
data_buffers["hourly"].append(new_entry)
data_buffers["hourly"] = trim_data(data_buffers["hourly"], 3600)  # Última hora

# Guardar datos actualizados
for key, path in data_paths.items():
    save_data(path, data_buffers[key])

# Función para generar gráficas
def generate_plot(data, index, title, ylabel, save_path, ylim=None):
    if not data:
        print(f"No hay datos disponibles para {title}. Omitiendo gráfica.")
        return

    timestamps = [row[0] for row in data]
    values = [row[index] for row in data]

    plt.figure(figsize=(10, 6))
    plt.plot(timestamps, values, label=title, marker='o', linestyle='-')
    plt.grid(True)
    if ylim:
        plt.ylim(ylim)
    plt.title(title)
    plt.xlabel('Tiempo')
    plt.ylabel(ylabel)
    plt.legend()
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.savefig(save_path)
    plt.close()

# Configuración de gráficas
plot_configs = [
    (1, 'Uso de CPU', 'Porcentaje de Uso', (0, 100)),
    (2, 'Uso de RAM', 'Porcentaje de Uso', (0, 100)),
    (3, 'Uso de Disco', 'Porcentaje de Uso', (0, 100)),
    (4, 'Descarga', 'Mbps', None),
    (5, 'Subida', 'Mbps', None),
    (6, 'Temperatura', 'Temperatura (°C)', None),
    (7, 'Conexiones Activas', 'Conexiones', None),
]

# Generar gráficas
for index, title, ylabel, ylim in plot_configs:
    generate_plot(
        data_buffers["hourly"],
        index,
        title,
        ylabel,
        os.path.join(plot_folders["hourly"], f'{title.lower().replace(" ", "_")}_hourly.jpg'),
        ylim,
    )

print("Métricas actualizadas y gráficas generadas correctamente.")
