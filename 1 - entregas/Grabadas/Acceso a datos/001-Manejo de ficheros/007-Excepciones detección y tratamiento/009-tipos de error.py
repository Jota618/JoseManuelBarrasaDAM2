import json
import os
import errno

# Declaro una clase Cliente con las propiedades idcliente, nombre, apellidos y un diccionario de emails
class Cliente:
    def __init__(self):
        self.idcliente = None  # Inicializa el id del cliente como None
        self.nombre = None  # Inicializa el nombre del cliente como None
        self.apellidos = None  # Inicializa los apellidos del cliente como None
        self.emails = {"personal": [], "profesional": []}  # Diccionario para almacenar emails personales y profesionales
    
    def to_dict(self):  # Método para convertir un objeto Cliente a diccionario
        return {
            "nombre": self.nombre,  # Devuelve el nombre
            "apellidos": self.apellidos,  # Devuelve los apellidos
            "emails": self.emails  # Devuelve el diccionario de emails
        }

# Declaro una clase Producto con las propiedades nombre, precio, peso y dimensiones
class Producto:
    def __init__(self):
        self.nombre = None  # Inicializa el nombre del producto como None
        self.precio = None  # Inicializa el precio del producto como None
        self.peso = None  # Inicializa el peso del producto como None
        self.dimensiones = {"x": None, "y": None, "z": None}  # Diccionario para almacenar dimensiones del producto

carpeta = "basededatos"  # Nombre de la carpeta donde se guardarán los archivos
continuas = True  # Variable para controlar si seguimos adelante o no

# Intento crear la carpeta para la base de datos
try:
    os.makedirs(carpeta)  # Crea la carpeta "basededatos"
except OSError as e:
    if e.errno == errno.EEXIST:  # Si ya existe la carpeta, lo indicamos
        print(f"La carpeta ya existe.")
    elif e.errno == errno.EACCES:  # Si hay problemas de permisos, detenemos la ejecución
        continuas = False
        print("Error de permisos en la carpeta - no puedo guardar")
    else:  # Para cualquier otro error, mostramos un mensaje genérico
        print(f"Unexpected error: {e}")

# Si se puede continuar, añadimos clientes a la lista
if continuas:
    clientes = []  # Inicializamos una lista vacía de clientes

    # Añadimos un cliente a la lista
    clientes.append(Cliente())  
    clientes[-1].idcliente = "00001"  # Asignamos ID al cliente
    clientes[-1].nombre = "Jose Manuel"  # Asignamos nombre
    clientes[-1].apellidos = "Barrasa"  # Asignamos apellidos
    clientes[-1].emails['profesional'].append("barrasa@gmail.com")  # Añadimos un email profesional
    clientes[-1].emails['personal'].append("jose@gmail.com")  # Añadimos un email personal

    # Añadimos otro cliente a la lista
    clientes.append(Cliente())  
    clientes[-1].idcliente = "00002"  # Asignamos ID al segundo cliente
    clientes[-1].nombre = "Jorge"  # Asignamos nombre
    clientes[-1].apellidos = "Lopez martinez"  # Asignamos apellidos
    clientes[-1].emails['profesional'].append("jorge@josevicentecarratala.com")  # Añadimos un email profesional
    clientes[-1].emails['profesional'].append("jorge@jocarsa.com")  # Añadimos otro email profesional
    clientes[-1].emails['personal'].append("jorge@gmail.com")  # Añadimos un email personal

    # Recorremos la lista de clientes y guardamos sus datos en archivos JSON
    for cliente in clientes:
        archivo = open(carpeta + "/" + cliente.idcliente + ".json", 'w')  # Abrimos un archivo con el ID del cliente
        json.dump(cliente.to_dict(), archivo, indent=4)  # Guardamos los datos del cliente en formato JSON
        archivo.close()  # Cerramos el archivo para asegurarnos de que se guarda correctamente