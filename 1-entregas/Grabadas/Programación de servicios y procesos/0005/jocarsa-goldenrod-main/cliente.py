import socket
import json
import os
import sys

def cargar_configuracion_cliente(ruta_configuracion='client_config_sample.json'):
    if not os.path.exists(ruta_configuracion):
        print(f"[ERROR] Archivo de configuración del cliente '{ruta_configuracion}' no encontrado.")
        sys.exit(1)
    try:
        with open(ruta_configuracion, 'r') as archivo_configuracion:
            configuracion = json.load(archivo_configuracion)
            # Validar campos requeridos
            campos_requeridos = ['server_host', 'server_port']
            for campo in campos_requeridos:
                if campo not in configuracion:
                    raise ValueError(f"Falta '{campo}' en la configuración del cliente.")
            return configuracion
    except json.JSONDecodeError as e:
        print(f"[ERROR] Error al analizar '{ruta_configuracion}': {e}")
        sys.exit(1)
    except ValueError as ve:
        print(f"[ERROR] {ve}")
        sys.exit(1)

def cargar_historial():
    """Carga el historial de mensajes desde un archivo de texto."""
    historial = []
    if os.path.exists("historial_mensajes.txt"):
        with open("historial_mensajes.txt", 'r') as archivo:
            historial = archivo.readlines()
    return historial

def guardar_en_historial(mensaje, tipo="Enviado"):
    """Guarda un mensaje en el archivo de historial."""
    with open("historial_mensajes.txt", 'a') as archivo:
        archivo.write(f"{tipo}: {mensaje}\n")

def mostrar_historial():
    """Muestra el historial de mensajes al usuario."""
    historial = cargar_historial()
    if historial:
        print("\n--- Historial de Mensajes ---")
        for mensaje in historial:
            print(mensaje.strip())
        print("-----------------------------\n")
    else:
        print("[INFO] No hay historial de mensajes.\n")

def iniciar_cliente():
    # Cargar configuración del cliente
    configuracion = cargar_configuracion_cliente()

    SERVIDOR_HOST = configuracion['server_host']
    SERVIDOR_PUERTO = configuracion['server_port']

    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as cliente:
        try:
            # Conectar al servidor
            cliente.connect((SERVIDOR_HOST, SERVIDOR_PUERTO))
            print(f"[CONECTADO] Conectado al servidor en {SERVIDOR_HOST}:{SERVIDOR_PUERTO}")

            while True:
                # Mostrar el historial de mensajes si el usuario lo solicita
                opcion = input("¿Quieres ver el historial de mensajes? (s/n): ").lower()
                if opcion == 's':
                    mostrar_historial()

                # Obtener entrada del usuario
                mensaje = input("Introduce el mensaje a enviar (escribe 'salir' para salir): ")
                if mensaje.lower() == 'salir':
                    print("[DESCONECTANDO] Desconectando del servidor.")
                    break

                # Guardar el mensaje en el historial antes de enviarlo
                guardar_en_historial(mensaje, tipo="Enviado")

                # Enviar el mensaje al servidor
                cliente.sendall(mensaje.encode('utf-8'))

                # Esperar la respuesta del servidor
                respuesta = cliente.recv(1024)
                if not respuesta:
                    print("[DESCONECTADO] El servidor cerró la conexión.")
                    break

                # Decodificar e imprimir la respuesta
                print(f"Respuesta del servidor: {respuesta.decode('utf-8')}")

                # Guardar la respuesta en el historial
                guardar_en_historial(respuesta.decode('utf-8'), tipo="Recibido")

        except ConnectionRefusedError:
            print(f"[ERROR] No se pudo conectar al servidor en {SERVIDOR_HOST}:{SERVIDOR_PUERTO}. ¿Está el servidor en ejecución?")
        except socket.gaierror:
            print(f"[ERROR] Dirección del servidor no válida: {SERVIDOR_HOST}")
        except KeyboardInterrupt:
            print("\n[SALIDA] Cliente terminado por el usuario.")
        except Exception as e:
            print(f"[ERROR] Ocurrió un error inesperado: {e}")

if __name__ == "__main__":
    iniciar_cliente()
