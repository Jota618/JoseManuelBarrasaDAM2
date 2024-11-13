import json                                                             # importamos json como librería para automatizar cosas como el guardado
import os                                                               # Me permite realizar operaciones con el sistema de archivos del OS
import errno                                                            # Gestiona y captura los diferentes tipos de error para poder operar sobre cada uno de ellos
import tkinter as tk

class Cliente:
    def __init__(self,
                 idcliente,
                 nuevonombre,
                 nuevosapellidos,
                 listapersonal,
                 listaprofesional
                 ):
        self.idcliente = idcliente
        self.nombre = nuevonombre
        self.apellidos = nuevosapellidos
        self.emails = {
            "personal":listapersonal,
            "profesional":listaprofesional
            }
    def to_dict(self):
        return {
            "nombre": self.nombre,
            "apellidos": self.apellidos,
            "emails": self.emails
        }

carpeta = "basededatos"
continuas = True
clientes = []


try:
    os.makedirs(carpeta)
except OSError as e:
    if e.errno == errno.EEXIST:
        print(f"La carpeta ya existe.")
    elif e.errno == errno.EACCES:
        continuas = False
        print("Error de permisos en la carpeta - no puedo guardar")
    else:
        print(f"Unexpected error: {e}")

def guardaCliente():
    global clientes
    clientes.append(
        Cliente(
            idcliente.get(),
            nombre.get(),
            apellidos.get(),
            personal.get(),
            profesional.get()
            )
        )
def guardaDB():
    for cliente in clientes:
        archivo = open(carpeta+"/"+cliente.idcliente+".json",'w')
        json.dump(cliente.to_dict(),archivo,indent=4)
        archivo.close()

ventana = tk.Tk()
marco = tk.Frame(ventana,padx=20,pady=20)
marco.pack(padx=20,pady=20)

nombre = tk.StringVar()
apellidos = tk.StringVar()
idcliente = tk.StringVar()
personal = tk.StringVar()
profesional = tk.StringVar()

tk.Label(marco,text="Id de cliente").pack(padx=10,pady=10)
tk.Entry(marco,textvariable=idcliente).pack(padx=10,pady=10)
tk.Label(marco,text="Nombre").pack(padx=10,pady=10)
tk.Entry(marco,textvariable=nombre).pack(padx=10,pady=10)
tk.Label(marco,text="Apellidos").pack(padx=10,pady=10)
tk.Entry(marco,textvariable=apellidos).pack(padx=10,pady=10)
tk.Label(marco,text="Email personal").pack(padx=10,pady=10)
tk.Entry(marco,textvariable=personal).pack(padx=10,pady=10)
tk.Label(marco,text="Email profesional").pack(padx=10,pady=10)
tk.Entry(marco,textvariable=profesional).pack(padx=10,pady=10)
tk.Button(marco,text="Guardamos este cliente",command=guardaCliente).pack(padx=10,pady=10)
tk.Button(marco,text="Guardamos todos los clientes a base de datos",command=guardaDB).pack(padx=10,pady=10)


ventana.mainloop()




        


