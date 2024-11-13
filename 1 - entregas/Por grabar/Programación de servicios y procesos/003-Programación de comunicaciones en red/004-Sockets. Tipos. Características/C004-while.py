import socket                                                                   # Importo la librería de sockets

import os

def clear_screen():
    # Check the operating system and call the appropriate command
    if os.name == 'nt':  # For Windows
        os.system('cls')
    else:  # For macOS or Linux
        os.system('clear')

cliente = socket.socket(socket.AF_INET, socket.SOCK_STREAM)                     # Creo un cliente

cliente.connect(('localhost', 9993))                                            # Me conecto en la dirección y el puerto donde SÉ que hay un servidor escuchando

while True:                                                                     # entro en un bucle
    mimensaje = input("Dime tu mensaje: ")                                      # Atrapo la entrada del usuario

    cliente.send(mimensaje.encode('utf-8'))                                    # Le envío el mensaje desde el cliente hasta el servidor

    respuesta = cliente.recv(1024).decode('utf-8')                              # Cuando reciba una respusta por parte del servidor
    clear_screen()
    print(f"{respuesta}")                  # Digo que he recibido una respuesta

    if mimensaje.lower() == 'salir':                                            # Si el usuario indica "salir"
        print("Cerrando la conexión con el servidor.")                          # Imprime un mensaje
        break                                                                   # Sal del bucle, cierra la conexion


    
cliente.close()                                                                 # Cierra la conexión
