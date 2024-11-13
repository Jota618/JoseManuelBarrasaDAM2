import json                                                             # importamos json como librería para automatizar cosas como el guardado
import os                                                               # Me permite realizar operaciones con el sistema de archivos del OS
import errno                                                            # Gestiona y captura los diferentes tipos de error para poder operar sobre cada uno de ellos
import tkinter as tk                                                    # Librería para generar interfaces de usuario

class Cliente:                                                          # Declaro clase cliente
    def __init__(self,                          
                 idcliente,
                 nuevonombre,
                 nuevosapellidos,
                 listapersonal,
                 listaprofesional
                 ):                                                     # Utilizo un constructor con parametros para creación abreviada
        self.idcliente = idcliente                                      # Asigno parámetro a propiedad
        self.nombre = nuevonombre
        self.apellidos = nuevosapellidos
        self.emails = {
            "personal":listapersonal,
            "profesional":listaprofesional
            }                                                           # Algunas propiedades pueden ser estructuras de datos complejas y multinivel
    def to_dict(self):                                                  # Creo un método para convertir las propiedades en un diccionario, para poder persistir
        return {
            "nombre": self.nombre,
            "apellidos": self.apellidos,
            "emails": self.emails
        }                                                               # Devuelvo un diccionario con las propiedades

######### Variables globales
    
carpeta = "basededatos"                                                 # Nombre de la carpeta que guarda los datos
clientes = []                                                           # Creo una lista vacía original de clientes


try:                                                                    # Realizo un intento
    os.makedirs(carpeta)                                                # Intento crear la carpeta de bases de datos por si no existe
except OSError as e:                                                    # Si no puedo, capturo el error
    if e.errno == errno.EEXIST:                                         # Si la carpeta ya existe
        print(f"La carpeta ya existe.")                                 # No pasa nada, podemos continuar
    elif e.errno == errno.EACCES:                                       # Si el error es que no tengo acceso
        print("Error de permisos en la carpeta - no puedo guardar")     # De momento hago un print, pero tendría que hacer algo más elaborado
    else:                                                               # En cualquier caso que no este contemplado en los anteriores
        print(f"Unexpected error: {e}")                                 # Por lo menos de cara a debug dime que hay

def guardaCliente():                                                    # Funcion de guardar cliente para cuando pulsemos el boton 1
    global clientes                                                     # Meto en esta funcion la variable clientes
    clientes.append(
        Cliente(
            idcliente.get(),
            nombre.get(),
            apellidos.get(),
            personal.get(),
            profesional.get()
            )
        )                                                               # Añado a la lista de clientes una nueva instancia de la clase Cliente
    
def guardaDB():                                                         # Funcion de guardar los clientes en formato json en una carpeta
    for cliente in clientes:                                            # para cada uno de los clientes que esté en la lista
        archivo = open(carpeta+"/"+cliente.idcliente+".json",'w')       # abre un archivo y nombralo con el id de cliente
        json.dump(cliente.to_dict(),archivo,indent=4)                   # Coge el diccionario del cliente y guardalo pretty print en el archivo
        archivo.close()                                                 # Cerramos ese archivo por si acaso

ventana = tk.Tk()                                                       # Creamos una ventana
marco = tk.Frame(ventana,padx=20,pady=20)                               # Creamos un marco para agrupar los elementos de la interfaz
marco.pack(padx=20,pady=20)                                             # Empaquetamos el marco a la ventana

# Variables especificas de tkinter para almacenar informacion

nombre = tk.StringVar()                                                 # creamos una variable para recoger el nombre           
apellidos = tk.StringVar()                                              # Variable para recoger los apellidos
idcliente = tk.StringVar()                                              # Variable para recoger el id de cliente
personal = tk.StringVar()                                               # Variable para recoger los correos personales
profesional = tk.StringVar()                                            # Variable para recoger los correos profesionales

tk.Label(marco,text="Id de cliente").pack(padx=10,pady=10)              # Etiqueta
tk.Entry(marco,textvariable=idcliente).pack(padx=10,pady=10)            # Campo en el que recogemos el id de cliente
tk.Label(marco,text="Nombre").pack(padx=10,pady=10)                     # Etiqueta
tk.Entry(marco,textvariable=nombre).pack(padx=10,pady=10)               # Campo en el que recogemos el nombre del cliente
tk.Label(marco,text="Apellidos").pack(padx=10,pady=10)                  # Etiqueta
tk.Entry(marco,textvariable=apellidos).pack(padx=10,pady=10)            # Campo en el que recogemos los apellidos del clienrte
tk.Label(marco,text="Email personal").pack(padx=10,pady=10)             # Etiqueta
tk.Entry(marco,textvariable=personal).pack(padx=10,pady=10)             # Campo en el que recogemos el email personal del cliente
tk.Label(marco,text="Email profesional").pack(padx=10,pady=10)          # Etiqueta
tk.Entry(marco,textvariable=profesional).pack(padx=10,pady=10)          # Campo en el que recogemos el email profesional del cliente
tk.Button(marco,text="Guardamos este cliente",command=guardaCliente).pack(padx=10,pady=10)  # Boton para guardar un cliente
tk.Button(marco,text="Guardamos todos los clientes a base de datos",command=guardaDB).pack(padx=10,pady=10) # Boton para guardar todos los clientes


ventana.mainloop()                                                      # Esto impide que la ventana se cierre y ejecuta el bucle




        


