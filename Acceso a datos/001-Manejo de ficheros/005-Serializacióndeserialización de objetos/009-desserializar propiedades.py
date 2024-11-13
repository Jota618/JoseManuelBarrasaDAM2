import random
import math
# Declaro una clase Npc y le pongo dos sencillas propiedades x e y
class Npc:
    def __init__(self,nuevax,nuevay,nuevoangulo):
        self.x = nuevax
        self.y = nuevay
        self.angulo = nuevoangulo

        
# Creo una lista de 50 npcs
npcs = []

# Leo el contenido de la base de datos
archivo = open("basededatos.txt",'r')
contenido = archivo.read()
print(contenido)

objetos = contenido.split("|")
for objeto in objetos:
    try:
        propiedades = objeto.split(",")
        print(propiedades)
        npcs.append(Npc(propiedades[0],propiedades[1],propiedades[2]))
    except:
        print("Ha ocurrido algún error pero que vamos que no te preocupes")

#Ahora por ultimo vamos a ver si todo ha ido bien
for npc in npcs:
    print(npc.x,npc.y,npc.angulo)
