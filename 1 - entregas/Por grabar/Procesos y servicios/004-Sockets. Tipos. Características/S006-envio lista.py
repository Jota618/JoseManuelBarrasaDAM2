import socket  # Biblioteca para implementar comunicación cliente-servidor mediante sockets
import threading  # Biblioteca para manejar múltiples clientes con hilos separados

contador = 1  # Contador global no utilizado en el código actual
mensajes = []  # Lista para almacenar mensajes recibidos de los clientes
clientes = {}  # Diccionario para asociar clientes con sus nombres de usuario

# Función para manejar la comunicación con un cliente específico
def handle_client(client_socket, addr):
    global mensajes, clientes
    print(f"Conexión establecida con: {addr}")

    try:
        # Solicita al cliente un nombre de usuario al conectarse
        client_socket.send("Introduce tu nombre de usuario: ".encode('utf-8'))
        username = client_socket.recv(1024).decode('utf-8').strip()
        clientes[client_socket] = username
        print(f"El cliente {addr} se identificó como: {username}")

        # Notifica a todos los clientes sobre la nueva conexión
        broadcast(f"{username} se ha unido al chat.\n", client_socket)
    except Exception as e:
        print(f"Error al obtener el nombre de usuario de {addr}: {e}")
        client_socket.close()
        return

    while True:
        try:
            # Recibe un mensaje del cliente (máx. 1024 bytes) y lo decodifica
            message = client_socket.recv(1024).decode('utf-8')
            if not message:
                print(f"El cliente {addr} ({username}) ha cerrado la conexión.")
                break

            # Verifica si es un mensaje privado
            if message.startswith("@"):  # Formato: @usuario mensaje
                destinatario, contenido = parse_private_message(message)
                enviar_mensaje_privado(destinatario, contenido, username)
            else:
                mensajes.append(f"{username}: {message}")  # Guarda el mensaje en la lista global
                broadcast(f"{username}: {message}\n", client_socket)  # Envía el mensaje a todos los clientes

        except ConnectionResetError:
            print(f"El cliente {addr} ({username}) ha cerrado la conexión inesperadamente.")
            break

    # Cierra la conexión con el cliente y elimina su entrada del diccionario
    del clientes[client_socket]
    client_socket.close()
    broadcast(f"{username} ha salido del chat.\n", client_socket)

# Envía un mensaje a todos los clientes conectados, excepto al remitente
def broadcast(message, remitente):
    for client in clientes:
        if client != remitente:
            try:
                client.send(message.encode('utf-8'))
            except:
                client.close()
                del clientes[client]

# Parsea un mensaje privado para extraer el destinatario y el contenido
def parse_private_message(message):
    parts = message.split(" ", 2)  # Divide en "@usuario mensaje"
    destinatario = parts[0][1:]  # Elimina el "@"
    contenido = parts[1] if len(parts) > 1 else ""
    return destinatario, contenido

# Envía un mensaje privado a un cliente

def enviar_mensaje_privado(destinatario, contenido, remitente):
    encontrado = False
    for client, username in clientes.items():
        if username == destinatario:
            try:
                client.send(f"Mensaje privado de {remitente}: {contenido}\n".encode('utf-8'))
                encontrado = True
                break
            except:
                client.close()
                del clientes[client]
    if not encontrado:
        print(f"Usuario destinatario {destinatario} no encontrado.")

# Guarda los mensajes en un archivo para persistencia
def guardar_log_mensajes():
    with open("chat_log.txt", "a") as log_file:
        for mensaje in mensajes:
            log_file.write(mensaje + "\n")

# Configuración del servidor
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)  # Crea un socket TCP/IP
server.bind(('localhost', 9993))  # Asigna el servidor a la dirección 'localhost' y puerto 9993
server.listen(5)  # Permite un máximo de 5 conexiones en espera

print("El servidor está escuchando en el puerto 9993...")

try:
    while True:  # Bucle infinito para aceptar conexiones de clientes
        client_socket, addr = server.accept()  # Acepta una nueva conexión entrante
        # Crea un nuevo hilo para manejar la comunicación con el cliente
        client_thread = threading.Thread(target=handle_client, args=(client_socket, addr))
        client_thread.start()  # Inicia el hilo
except KeyboardInterrupt:
    print("Servidor detenido manualmente.")
    guardar_log_mensajes()  # Guarda los mensajes en el archivo log antes de salir
    server.close()
