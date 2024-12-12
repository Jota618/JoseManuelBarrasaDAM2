import psutil  # Para obtener información del sistema
from datetime import datetime  # Para añadir marcas de tiempo
import matplotlib.pyplot as plt  # Para las gráficas en tiempo real
import time  # Para la ejecución periódica

# Función para registrar el uso total y por núcleo en un archivo
def registrar_uso_cpu(archivo_nombre):
    cpu_load_per_core = psutil.cpu_percent(interval=1, percpu=True)
    total_cpu_load = psutil.cpu_percent(interval=1)
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    # Guardar datos en el archivo
    with open(archivo_nombre, 'a') as archivo:
        archivo.write(f"{timestamp} - Total CPU load: {total_cpu_load}%\n")
        archivo.write(f"{timestamp} - Per core CPU load: {cpu_load_per_core}\n")

# Función para generar una gráfica en tiempo real del uso de la CPU
def mostrar_grafica_tiempo_real(intervalo, duracion):
    tiempos = []
    cargas_totales = []
    inicio = time.time()

    plt.ion()  # Activar modo interactivo para actualizar la gráfica en tiempo real
    fig, ax = plt.subplots()

    while time.time() - inicio < duracion:
        total_cpu_load = psutil.cpu_percent(interval=intervalo)
        tiempos.append(datetime.now().strftime('%H:%M:%S'))
        cargas_totales.append(total_cpu_load)

        # Actualizar gráfica
        ax.clear()
        ax.plot(tiempos, cargas_totales, label='Total CPU Load (%)', color='blue')
        ax.set_xlabel('Time')
        ax.set_ylabel('CPU Load (%)')
        ax.set_title('CPU Usage in Real Time')
        ax.legend()
        plt.xticks(rotation=45)
        plt.tight_layout()
        plt.pause(0.1)

    plt.ioff()  # Desactivar modo interactivo
    plt.show()

# Función principal para monitorear la CPU
def monitorear_cpu(archivo_nombre, intervalo=5, duracion=60):
    inicio = time.time()

    while time.time() - inicio < duracion:
        registrar_uso_cpu(archivo_nombre)
        time.sleep(intervalo)  # Pausa antes del siguiente registro

# Función para integrar todo
if __name__ == "__main__":
    archivo_nombre = "rendimiento_mejorado.txt"

    print("Inicio del monitoreo de CPU...")
    # Registrar uso de CPU y guardar en archivo durante 60 segundos, cada 5 segundos
    monitorear_cpu(archivo_nombre, intervalo=5, duracion=60)

    print("Generando gráfica en tiempo real...")
    # Mostrar una gráfica en tiempo real durante 30 segundos, actualizando cada segundo
    mostrar_grafica_tiempo_real(intervalo=1, duracion=30)

    print("Monitoreo finalizado.")

