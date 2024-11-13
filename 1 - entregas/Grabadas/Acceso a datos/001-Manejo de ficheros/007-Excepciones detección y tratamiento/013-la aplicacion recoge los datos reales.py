import json  # Importo la librería para trabajar con JSON
import os  # Importo la librería para manejar el sistema de archivos
import errno  # Importo la librería para manejar errores del sistema operativo
import tkinter as tk  # Importo tkinter para crear la interfaz gráfica

# Clase Cliente con parámetros para inicializar los valores de cada cliente
class Cliente:
    def __init__(self, idcliente, nuevonombre, nuevosapellidos, listapersonal, listaprofesional):
        self.idcliente = idcliente  # Inicializa el ID del cliente
        self.nombre = nuevonombre  # Inicializa el nombre del cliente
        self.apellidos = nuevosapellidos  # Inicializa los apellidos del cliente
        self.emails = {  # Diccionario para almacenar los emails personales y profesionales
            "personal": listapersonal,  # Lista de emails personales
            "profesional": listaprofesional  # Lista de emails profesionales
        }
    
    # Método para convertir el cliente en un diccionario
    def to_dict(self):
        return {
            "nombre": self.nombre,  # Retorna el nombre del cliente
            "apellidos": self.apellidos,  # Retorna los apellidos
            "emails": self.emails  # Retorna los emails
        }

carpeta = "basededatos"  # Nombre de la carpeta para almacenar los archivos JSON
continuas = True  # Controla si el proceso debe continuar
clientes = []  # Lista para almacenar los clientes

# Intento crear la carpeta para los archivos JSON
try:
    os.makedirs(carpeta)  # Crea la carpeta si no existe
except OSError as e:  # Si hay un error, lo maneja aquí
    if e.errno == errno.EEXIST:  # Si ya existe, lo informa
        print(f"La carpeta ya existe.")
    elif e.errno == errno.EACCES:  # Si no tiene permisos, lo informa
        continuas = False  # Detiene el proceso si no tiene permisos
        print("Error de permisos en la carpeta - no puedo guardar")
    else:  # Otros errores
        print(f"Unexpected error: {e}")

# Función para guardar un cliente en la lista
def guardaCliente():
    global clientes  # Hace referencia a la lista global de clientes
    clientes.append(
        Cliente(
            idcliente.get(),  # Obtiene el valor del campo de entrada para ID del cliente
            nombre.get(),  # Obtiene el valor del campo de entrada para el nombre
            apellidos.get(),  # Obtiene el valor del campo de entrada para los apellidos
            personal.get(),  # Obtiene el valor del campo de entrada para el email personal
            profesional.get()  # Obtiene el valor del campo de entrada para el email profesional
        )
    )

# Función para guardar todos los clientes en archivos JSON
def guardaDB():
    for cliente in clientes:  # Recorre la lista de clientes
        archivo = open(carpeta + "/" + cliente.idcliente + ".json", 'w')  # Crea un archivo JSON para cada cliente
        json.dump(cliente.to_dict(), archivo, indent=4)  # Guarda los datos del cliente en formato JSON
        archivo.close()  # Cierra el archivo después de escribir

# Creación de la ventana principal de la interfaz gráfica
ventana = tk.Tk()
marco = tk.Frame(ventana, padx=20, pady=20)  # Crea un marco con espacio de padding
marco.pack(padx=20, pady=20)  # Posiciona el marco dentro de la ventana

# Variables de Tkinter para enlazar con los campos de entrada
nombre = tk.StringVar()  # Variable para almacenar el nombre
apellidos = tk.StringVar()  # Variable para almacenar los apellidos
idcliente = tk.StringVar()  # Variable para almacenar el ID del cliente
personal = tk.StringVar()  # Variable para almacenar el email personal
profesional = tk.StringVar()  # Variable para almacenar el email profesional

# Creación de los campos de la interfaz con etiquetas y entradas
tk.Label(marco, text="Id de cliente").pack(padx=10, pady=10)  # Etiqueta para el ID del cliente
tk.Entry(marco, textvariable=idcliente).pack(padx=10, pady=10)  # Campo de entrada para el ID del cliente

tk.Label(marco, text="Nombre").pack(padx=10, pady=10)  # Etiqueta para el nombre
tk.Entry(marco, textvariable=nombre).pack(padx=10, pady=10)  # Campo de entrada para el nombre

tk.Label(marco, text="Apellidos").pack(padx=10, pady=10)  # Etiqueta para los apellidos
tk.Entry(marco, textvariable=apellidos).pack(padx=10, pady=10)  # Campo de entrada para los apellidos

tk.Label(marco, text="Email personal").pack(padx=10, pady=10)  # Etiqueta para el email personal
tk.Entry(marco, textvariable=personal).pack(padx=10, pady=10)  # Campo de entrada para el email personal

tk.Label(marco, text="Email profesional").pack(padx=10, pady=10)  # Etiqueta para el email profesional
tk.Entry(marco, textvariable=profesional).pack(padx=10, pady=10)  # Campo de entrada para el email profesional

# Botones para guardar un cliente o todos los clientes
tk.Button(marco, text="Guardamos este cliente", command=guardaCliente).pack(padx=10, pady=10)  # Botón para guardar un cliente
tk.Button(marco, text="Guardamos todos los clientes a base de datos", command=guardaDB).pack(padx=10, pady=10)  # Botón para guardar todos los clientes

# Bucle principal de la ventana
ventana.mainloop()  # Ejecuta la ventana y mantiene la interfaz abierta

