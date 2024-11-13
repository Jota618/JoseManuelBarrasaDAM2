import socket
import os
import threading
import time

def clear_screen():
    # Check the operating system and call the appropriate command
    if os.name == 'nt':  # For Windows
        os.system('cls')
    else:  # For macOS or Linux
        os.system('clear')

def recibir_mensajes(cliente):
    while True:
        try:
            respuesta = cliente.recv(1024).decode('utf-8')  # Recibe la respuesta del servidor
            if respuesta:
                clear_screen()
                print(f"Respuesta del servidor: {respuesta}")
        except socket.error:
            # Ignorar errores si no hay mensajes
            pass
        time.sleep(5)  # Pausar 5 segundos antes de verificar de nuevo

def enviar_mensajes(cliente):
    while True:
        mimensaje = input("Dime tu mensaje: ")  # Atrapo la entrada del usuario
        cliente.send(mimensaje.encode('utf-8'))  # Enviar el mensaje al servidor
        if mimensaje.lower() == 'salir':  # Si el usuario indica "salir"
            print("Cerrando la conexión con el servidor.")
            cliente.close()
            break

# Configuración del cliente
cliente = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
cliente.connect(('5.250.188.70', 3000))  # Me conecto en la dirección y el puerto donde sé que hay un servidor escuchando

# Crear hilos para recibir y enviar mensajes
thread_recibir = threading.Thread(target=recibir_mensajes, args=(cliente,))
thread_enviar = threading.Thread(target=enviar_mensajes, args=(cliente,))

# Iniciar hilos
thread_recibir.start()
thread_enviar.start()

# Esperar a que los hilos terminen
thread_enviar.join()
thread_recibir.join()

