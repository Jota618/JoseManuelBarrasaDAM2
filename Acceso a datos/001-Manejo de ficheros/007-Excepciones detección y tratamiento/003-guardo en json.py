import json

class Cliente:
    def __init__(self):
        self.nombre = None
        self.apellidos = None
        self.emails = {"personal":[],"profesional":[]}

class Producto:
    def __init__(self):
        self.nombre = None
        self.precio = None
        self.peso = None
        self.dimensiones = {"x":None,"y":None,"z":None}

clientes = []
clientes.append(Cliente())

clientes[-1].nombre = "Jose Vicente"
clientes[-1].apellidos = "Carratalá Sanchis"
clientes[-1].emails['profesional'].append("info@josevicentecarratala.com")
clientes[-1].emails['profesional'].append("info@jocarsa.com")
clientes[-1].emails['personal'].append("jocarsa2@gmail.com")

print(clientes[-1].emails)

archivo = open("clientes.json",'w')
json.dump(clientes[-1],archivo,indent=4)
archivo.close()


        


