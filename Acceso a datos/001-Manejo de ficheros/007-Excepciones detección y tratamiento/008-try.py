import json
import os

class Cliente:
    def __init__(self):
        self.idcliente = None
        self.nombre = None
        self.apellidos = None
        self.emails = {"personal":[],"profesional":[]}
    def to_dict(self):
        return {
            "nombre": self.nombre,
            "apellidos": self.apellidos,
            "emails": self.emails
        }

class Producto:
    def __init__(self):
        self.nombre = None
        self.precio = None
        self.peso = None
        self.dimensiones = {"x":None,"y":None,"z":None}

carpeta = "basededatos"
try:
    os.makedirs(carpeta)
except OSError as e:
    print(e)

clientes = []
clientes.append(Cliente())
clientes[-1].idcliente = "00001"
clientes[-1].nombre = "Jose Vicente"
clientes[-1].apellidos = "Carratalá Sanchis"
clientes[-1].emails['profesional'].append("info@josevicentecarratala.com")
clientes[-1].emails['profesional'].append("info@jocarsa.com")
clientes[-1].emails['personal'].append("jocarsa2@gmail.com")

clientes.append(Cliente())
clientes[-1].idcliente = "00002"
clientes[-1].nombre = "Jorge"
clientes[-1].apellidos = "Lopez martinez"
clientes[-1].emails['profesional'].append("jorge@josevicentecarratala.com")
clientes[-1].emails['profesional'].append("jorge@jocarsa.com")
clientes[-1].emails['personal'].append("jorge@gmail.com")

for cliente in clientes:
    archivo = open(cliente.idcliente+".json",'w')
    json.dump(cliente.to_dict(),archivo,indent=4)
    archivo.close()


        


