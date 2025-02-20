class Cliente: #Creamos una clase cliente con sus valores
    def __init__(self):
        self.nombre = None
        self.apellidos = None
        self.emails = {"personal":[],"profesional":[]}

class Producto: #Creamos una clase producto con sus valores
    def __init__(self):
        self.nombre = None
        self.precio = None
        self.peso = None
        self.dimensiones = {"x":None,"y":None,"z":None}

clientes = []
clientes.append(Cliente())

clientes[-1].nombre = "Jose Manuel"
clientes[-1].apellidos = "Barrasa"
clientes[-1].emails['profesional'].append("barrasa@gmail.com")
clientes[-1].emails['personal'].append("jose@gmail.com")

print(clientes[-1].emails)