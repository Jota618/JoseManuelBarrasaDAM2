import socket                                                                           # Importo la librería de cliente y servidor de sockets
import threading                                                                        # Importo la librería de thread para que cada cliente esté en un hilo diferente

contador = 1                                                                            # Creo un contador global


def handle_client(client_socket, addr):                                                 # Esta función se ejecuta cada vez que el cliente envía algo
    global contador                                                                     # Meto la variable contador dentro de la funcion
    print(f"Conexion establecida con: {addr}")                                          # Imprimo un mensaje para confirmar que el cliente se ha conectado
    while True:                                                                         # Entro en un bucle infinito                                                               
        try:                                                                            # Intento por si da error
            message = client_socket.recv(1024).decode('utf-8')                          # Intento recibir un mensaje del cliente (max 1024 b, y lo decodifico por si lleva caracteres especiales
            
            if not message:                                                             # Si ya no recibo mensajes
                print(f"El cliente {addr} ha cerrado la conexión.")                     # Asumo que el cliente se ha desconectado
                break                                                                   # Rompo la conexión con el cliente

            print(f"Mensaje recibido del cliente {addr}: {message}")                    # Digo el mensaje que he recibido por parte del cliente          
            contador+=1                                                                 # Le sumo uno al contador para demostrar el estado del servidor
            respuesta = f"Hola desde el servidor y el contador es {contador}"           # Formateo un mensaje al cliente
            
            client_socket.send(respuesta.encode('utf-8'))                               # Le envío el mensaje al cliente          
        
        except ConnectionResetError:                                                    # Capturo el error
            print(f"El cliente {addr} ha cerrado la conexión inesperadamente.")         # Imprimo un mensaje de error
            break                                                                       # Y salgo del bucle
    
    client_socket.close()                                                               # Cierro la conexión con el cliente


server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)                              # Creamos un nuevo servidor de sockets
server.bind(('localhost', 9996))                                                        # Especifico ruta y puerto de escucha
server.listen(5)                                                                        # Indico el máximo de cola para entrar

print("El servidor esta escuchando en: 9998...")

while True:                                                                             # El servidor entra en bucle infinito
    client_socket, addr = server.accept()                                               # Acepto la conexión de nuevos clientes
    client_thread = threading.Thread(target=handle_client, args=(client_socket, addr))  # PAra cada cliente arranco un nuevo hilo de ejecucion
    client_thread.start()                                                               # Arranco el hilo

