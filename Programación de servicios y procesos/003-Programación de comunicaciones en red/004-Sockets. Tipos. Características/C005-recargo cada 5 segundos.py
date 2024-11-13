import socket
import os
import time

def clear_screen():
    # Check the operating system and call the appropriate command
    if os.name == 'nt':  # For Windows
        os.system('cls')
    else:  # For macOS or Linux
        os.system('clear')

cliente = socket.socket(socket.AF_INET, socket.SOCK_STREAM)  # Creo un cliente

cliente.connect(('localhost', 9993))  # Me conecto en la dirección y el puerto donde sé que hay un servidor escuchando

try:
    while True:  # entro en un bucle
        # Atrapo la entrada del usuario
        mimensaje = input("Dime tu mensaje (o espera 5 segundos para recibir del servidor): ")

        # Enviar mensaje si el usuario proporciona uno
        if mimensaje:
            cliente.send(mimensaje.encode('utf-8'))  # Enviar el mensaje al servidor
            if mimensaje.lower() == 'salir':  # Si el usuario indica "salir"
                print("Cerrando la conexión con el servidor.")  # Imprime un mensaje
                break  # Sal del bucle y cierra la conexión

        # Recibir respuesta del servidor
        try:
            cliente.settimeout(5)  # Espera un máximo de 5 segundos para recibir una respuesta
            respuesta = cliente.recv(1024).decode('utf-8')  # Recibe la respuesta del servidor
            clear_screen()
            print(f"Respuesta del servidor: {respuesta}")
        except socket.timeout:
            print("Esperando mensajes del servidor...")

        time.sleep(5)  # Esperar 5 segundos antes de la siguiente interacción

except KeyboardInterrupt:
    print("Cerrando la conexión debido a interrupción del teclado.")

finally:
    cliente.close()  # Cierra la conexión
