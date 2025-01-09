import json

archivo = open("agenda.json","r")

cadena = json.load(archivo)

print(cadena)
