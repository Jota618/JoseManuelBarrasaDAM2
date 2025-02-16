import socket
import threading
import json
import os
import sys

def cargar_configuracion_servidor(ruta_configuracion='server_config_sample.json'):
    if not os.path.exists(ruta_configuracion):
        print(f"[ERROR] Archivo de configuración del servidor '{ruta_configuracion}' no encontrado.")
        sys.exit(1)
    try:
        with open(ruta_configuracion, 'r') as archivo_configuracion:
            configuracion = json.load(archivo_configuracion)
            # Validar campos requeridos
            campos_requeridos = ['host', 'port', 'message_file']
            for campo in campos_requeridos:
                if campo not in configuracion:
                    raise ValueError(f"Falta '{campo}' en la configuración del servidor.")
            return configuracion
    except json.JSONDecodeError as e:
        print(f"[ERROR] Error al analizar '{ruta_configuracion}': {e}")
        sys.exit(1)
    except ValueError as ve:
        print(f"[ERROR] {ve}")
        sys.exit(1)

def manejar_cliente(conexion, direccion, archivo_mensajes):
    print(f"[NUEVA CONEXIÓN] {direccion} se ha conectado.")
    with conexion:
        try:
            while True:
                datos = conexion.recv(1024)  # Recibir datos del cliente
                if not datos:
                    break  # No hay más datos, el cliente cerró la conexión
                mensaje = datos.decode('utf-8')
                print(f"[RECIBIDO] {direccion}: {mensaje}")

                # Guardar el mensaje en un archivo de texto
                with open(archivo_mensajes, 'a') as archivo:
                    archivo.write(f"{direccion}: {mensaje}\n")

                # Preparar y enviar una respuesta al cliente
                respuesta = f"El servidor recibió tu mensaje: {mensaje}"
                conexion.sendall(respuesta.encode('utf-8'))
        except ConnectionResetError:
            print(f"[DESCONECTADO] La conexión con {direccion} se ha restablecido.")
    print(f"[DESCONECTADO] {direccion} se ha desconectado.")

def iniciar_servidor():
    # Cargar configuración del servidor
    configuracion = cargar_configuracion_servidor()

    HOST = configuracion['host']
    PUERTO = configuracion['port']
    ARCHIVO_MENSAJES = configuracion['message_file']

    # Crear un socket TCP/IP
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as servidor:
        # Permitir la reutilización de la dirección
        servidor.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        # Enlazar el socket a la dirección y puerto
        try:
            servidor.bind((HOST, PUERTO))
        except socket.error as e:
            print(f"[ERROR] No se pudo enlazar a {HOST}:{PUERTO}: {e}")
            sys.exit(1)
        servidor.listen()
        print(f"[ESCUCHANDO] El servidor está escuchando en {HOST}:{PUERTO}")

        while True:
            # Esperar una nueva conexión de cliente
            conexion, direccion = servidor.accept()
            # Manejar la conexión del cliente en un nuevo hilo
            hilo_cliente = threading.Thread(target=manejar_cliente, args=(conexion, direccion, ARCHIVO_MENSAJES))
            hilo_cliente.start()
            print(f"[CONEXIONES ACTIVAS] {threading.active_count() - 1}")

if __name__ == "__main__":
    print("[INICIANDO] El servidor está iniciando...")
    iniciar_servidor()
