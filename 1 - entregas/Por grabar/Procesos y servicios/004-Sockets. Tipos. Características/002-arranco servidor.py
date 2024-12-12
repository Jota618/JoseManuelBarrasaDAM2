############### SERVIDOR

import socket

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(('localhost', 9999))

server.listen(1)

print(f"El servidor esta escuchando en:9999...")

client_socket, addr = server.accept()

print(f"Conexion establecida con: {addr}")

mensaje = "Hola desde el servidor"
client_socket.send(mensaje.encode('utf-8'))

client_socket.close()
