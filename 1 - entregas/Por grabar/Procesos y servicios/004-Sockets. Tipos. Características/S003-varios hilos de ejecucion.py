import socket
import threading

# Function to handle client connection
def handle_client(client_socket, addr):
    print(f"Conexion establecida con: {addr}")
    
    while True:
        try:
            message = client_socket.recv(1024).decode('utf-8')
            
            if not message:
                print(f"El cliente {addr} ha cerrado la conexión.")
                break

            print(f"Mensaje recibido del cliente {addr}: {message}")
            
            respuesta = "Hola desde el servidor"
            client_socket.send(respuesta.encode('utf-8'))
        
        except ConnectionResetError:
            print(f"El cliente {addr} ha cerrado la conexión inesperadamente.")
            break
    
    client_socket.close()

# Server setup
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(('localhost', 9997))
server.listen(5)

print("El servidor esta escuchando en: 9998...")

while True:
    client_socket, addr = server.accept()
    # Create a new thread for each client
    client_thread = threading.Thread(target=handle_client, args=(client_socket, addr))
    client_thread.start()

