############### SERVIDOR

import socket

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(('localhost', 9998))

server.listen(5)

print(f"El servidor esta escuchando en:9999...")

client_socket, addr = server.accept()

print(f"Conexion establecida con: {addr}")

while True:
    message = client_socket.recv(1024).decode('utf-8')
    
    if not message:
        print("El cliente ha cerrado la conexión.")
        break

    print(f"Mensaje recibido del cliente: {message}")
    
    respuesta = "Hola desde el servidor"
    client_socket.send(respuesta.encode('utf-8'))
    

client_socket.close()
