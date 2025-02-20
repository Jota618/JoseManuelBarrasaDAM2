import json
import os
import errno
import tkinter as tk

# Clase Cliente con las propiedades idcliente, nombre, apellidos y emails
class Cliente:
    def __init__(self):
        self.idcliente = None  # Inicializa el id del cliente como None
        self.nombre = None  # Inicializa el nombre del cliente como None
        self.apellidos = None  # Inicializa los apellidos del cliente como None
        self.emails = {"personal": [], "profesional": []}  # Diccionario para almacenar emails personales y profesionales
    
    # Convierte el objeto Cliente a diccionario
    def to_dict(self):
        return {
            "nombre": self.nombre,  # Devuelve el nombre
            "apellidos": self.apellidos,  # Devuelve los apellidos
            "emails": self.emails  # Devuelve el diccionario de emails
        }

# Clase Producto con las propiedades nombre, precio, peso y dimensiones
class Producto:
    def __init__(self):
        self.nombre = None  # Inicializa el nombre del producto como None
        self.precio = None  # Inicializa el precio del producto como None
        self.peso = None  # Inicializa el peso del producto como None
        self.dimensiones = {"x": None, "y": None, "z": None}  # Diccionario para almacenar dimensiones del producto

carpeta = "basededatos"  # Nombre de la carpeta donde se guardarán los archivos
continuas = True  # Variable de control para saber si seguir con el proceso

# Intento crear la carpeta para la base de datos
try:
    os.makedirs(carpeta)  # Crea la carpeta "basededatos"
except OSError as e:  # Manejo de excepciones si hay algún error
    if e.errno == errno.EEXIST:  # Si la carpeta ya existe
        print(f"La carpeta ya existe.")
    elif e.errno == errno.EACCES:  # Si hay problemas de permisos
        continuas = False  # Se interrumpe el proceso
        print("Error de permisos en la carpeta - no puedo guardar")
    else:  # Otros errores
        print(f"Unexpected error: {e}")

# Creación de la ventana principal de la interfaz gráfica
ventana = tk.Tk()

# Marco que contiene los widgets con espacio adicional de padding
marco = tk.Frame(ventana, padx=20, pady=20)
marco.pack(padx=20, pady=20)

# Etiquetas y campos de entrada para ingresar los datos del cliente
tk.Label(marco, text="Id de cliente").pack(padx=10, pady=10)  # Etiqueta para ID del cliente
tk.Entry(marco).pack(padx=10, pady=10)  # Campo de entrada para ID del cliente

tk.Label(marco, text="Nombre").pack(padx=10, pady=10)  # Etiqueta para el nombre
tk.Entry(marco).pack(padx=10, pady=10)  # Campo de entrada para el nombre

tk.Label(marco, text="Apellidos").pack(padx=10, pady=10)  # Etiqueta para los apellidos
tk.Entry(marco).pack(padx=10, pady=10)  # Campo de entrada para los apellidos

tk.Label(marco, text="Email personal").pack(padx=10, pady=10)  # Etiqueta para el email personal
tk.Entry(marco).pack(padx=10, pady=10)  # Campo de entrada para el email personal

tk.Label(marco, text="Email profesional").pack(padx=10, pady=10)  # Etiqueta para el email profesional
tk.Entry(marco).pack(padx=10, pady=10)  # Campo de entrada para el email profesional

# Botón para guardar un cliente específico, llama a la función guardaCliente
tk.Button(marco, text="Guardamos este cliente", command=guardaCliente).pack(padx=10, pady=10)

# Botón para guardar todos los clientes en la base de datos, llama a la función guardaDB
tk.Button(marco, text="Guardamos todos los clientes a base de datos", command=guardaDB).pack(padx=10, pady=10)

# Bucle principal de la ventana para que se mantenga abierta
ventana.mainloop()  # Ejecuta la ventana y mantiene la interfaz abierta
