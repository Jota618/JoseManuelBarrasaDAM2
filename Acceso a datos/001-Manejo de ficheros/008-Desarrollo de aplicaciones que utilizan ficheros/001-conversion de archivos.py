import json
import xml

with open('cliente.json', 'r') as archivo:
    datos = json.load(archivo)

print(datos)


