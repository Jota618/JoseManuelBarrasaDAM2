import os
import json
import ipaddress
import random

# Archivo donde se guardarán las IPs bloqueadas
BLOQUEO_IPS_JSON = "ips_bloqueadas.json"
LOG_LOCAL = "access.log"  # Archivo de log local

# Lista de user agents (agentes de usuario) simulando diferentes navegadores
navegadores = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.81 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Firefox/92.0 Safari/537.36",
    "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:40.0) Gecko/20100101 Firefox/40.0",
    "Mozilla/5.0 (Linux; Android 10; Pixel 3 XL) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
    "Mozilla/5.0 (Windows NT 6.1; Trident/7.0; AS; AS; .NET CLR 4.0.30319; AS; rv:11.0) like Gecko",
    "Mozilla/5.0 (iPhone; CPU iPhone OS 13_5_1 like Mac OS X) AppleWebKit/537.36 (KHTML, like Gecko) Version/13.1 Mobile/15E148 Safari/537.36"
]

# Lista de países
paises = [
    "USA", "Canada", "Mexico", "Germany", "France", "UK", "Italy", "Spain", "Australia", "Brazil", "India", "Russia", "China", "Japan", "South Korea"
]

# Función para cargar IPs bloqueadas
def cargar_ips_bloqueadas():
    if os.path.exists(BLOQUEO_IPS_JSON):
        with open(BLOQUEO_IPS_JSON, 'r') as f:
            return json.load(f)
    return {}

# Función para guardar IPs bloqueadas
def guardar_ips_bloqueadas(ips_bloqueadas):
    with open(BLOQUEO_IPS_JSON, 'w') as f:
        json.dump(ips_bloqueadas, f, indent=4)

# Función para mostrar las IPs bloqueadas con países
def mostrar_ips_bloqueadas():
    ips = cargar_ips_bloqueadas()
    if not ips:
        print("No hay IPs bloqueadas.")
    else:
        print("IPs bloqueadas junto con los países:")
        for ip, info in ips.items():
            print(f"{ip} ({info['pais']}): {info['count']} veces")

# Función para generar y añadir IPs ficticias de forma aleatoria
def generar_ips_ficticias():
    ips_ficticias = []
    ips_bloqueadas = {}
    
    # Generamos un número aleatorio de IPs entre 5 y 15
    num_ips = random.randint(5, 15)
    
    for _ in range(num_ips):
        # Generar una IP aleatoria en el rango de direcciones IPv4
        ip = f"{random.randint(1, 223)}.{random.randint(0, 255)}.{random.randint(0, 255)}.{random.randint(0, 255)}"
        # Escoger un navegador y un país aleatoriamente
        navegador = random.choice(navegadores)
        pais = random.choice(paises)
        
        # Añadir el log con la IP generada
        log_entry = f"{ip} - - [17/Feb/2025:12:{random.randint(10, 59)}:{random.randint(0, 59)} +0000] \"GET / HTTP/1.1\" 200 1042 \"-\" \"{navegador}\" \"{pais}\"\n"
        ips_ficticias.append(log_entry)
        
        # Actualizar el diccionario de IPs bloqueadas con país y número de visitas
        if ip in ips_bloqueadas:
            ips_bloqueadas[ip]['count'] += 1
        else:
            ips_bloqueadas[ip] = {'count': 1, 'pais': pais}
    
    # Guardar las IPs ficticias en el archivo de log (sobrescribe el archivo cada vez)
    with open(LOG_LOCAL, 'w') as f:
        f.writelines(ips_ficticias)
    
    # Guardar las IPs bloqueadas con la información de país
    guardar_ips_bloqueadas(ips_bloqueadas)
    print("IPs ficticias añadidas al log.")


# Función para analizar el log y bloquear IPs
def analizar_log():
    if not os.path.exists(LOG_LOCAL) or os.stat(LOG_LOCAL).st_size == 0:
        print(f"El archivo {LOG_LOCAL} no existe o está vacío. Creando con datos de prueba...")
        generar_ips_ficticias()
    
    with open(LOG_LOCAL, 'r') as f:
        lineas = f.readlines()
    
    diccionario_ips = {}
    for linea in lineas:
        try:
            ip = linea.split()[0].strip()
            ipaddress.IPv4Address(ip)  # Validar IP
            diccionario_ips[ip] = diccionario_ips.get(ip, 0) + 1
        except Exception:
            continue
    
    # Guardar en el archivo JSON con la información completa de país y conteo
    ips_bloqueadas = cargar_ips_bloqueadas()
    for ip, count in diccionario_ips.items():
        if ip not in ips_bloqueadas:
            ips_bloqueadas[ip] = {'count': count, 'pais': "Desconocido"}  # Por si no tiene país asociado
        else:
            ips_bloqueadas[ip]['count'] += count
    
    guardar_ips_bloqueadas(ips_bloqueadas)
    print("IPs analizadas y guardadas correctamente.")

# Función para borrar el archivo de log
def borrar_log():
    if os.path.exists(LOG_LOCAL):
        os.remove(LOG_LOCAL)
        print(f"El archivo {LOG_LOCAL} ha sido borrado.")
    else:
        print(f"El archivo {LOG_LOCAL} no existe.")

# Menú principal
def main():
    while True:
        print("\n1. Analizar log y bloquear IPs")
        print("2. Ver IPs bloqueadas")
        print("3. Borrar archivo de log")
        print("4. Salir")
        opcion = input("Selecciona una opción: ")

        if opcion == "1":
            analizar_log()
        elif opcion == "2":
            mostrar_ips_bloqueadas()
        elif opcion == "3":
            borrar_log()
        elif opcion == "4":
            print("Saliendo...")
            break
        else:
            print("Opción no válida.")

if __name__ == "__main__":
    main()
