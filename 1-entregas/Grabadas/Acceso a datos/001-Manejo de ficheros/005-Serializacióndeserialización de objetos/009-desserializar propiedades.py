import random  # Importo el módulo random
import math  # Importo el módulo math

# Declaro una clase Npc con tres propiedades: x, y y ángulo
class Npc:
    def __init__(self, nuevax, nuevay, nuevoangulo):
        self.x = nuevax  # Asigna la coordenada x
        self.y = nuevay  # Asigna la coordenada y
        self.angulo = nuevoangulo  # Asigna el ángulo

# Creo una lista vacía para almacenar los NPCs
npcs = []

# Abro el archivo "basededatos.txt" en modo lectura ('r') para leer el contenido
archivo = open("basededatos.txt", 'r')

# Leo todo el contenido del archivo y lo guardo en la variable 'contenido'
contenido = archivo.read()

# Imprimo el contenido del archivo para verificar lo que se ha leído
print(contenido)

# Divido el contenido por el carácter "|" para separar los datos de cada NPC
objetos = contenido.split("|")

# Recorro cada "objeto" que contiene las propiedades de un NPC
for objeto in objetos:
    try:
        # Divido cada objeto por comas para separar las propiedades x, y y ángulo
        propiedades = objeto.split(",")
        
        # Imprimo las propiedades para verificar cada una
        print(propiedades)
        
        # Añado un nuevo NPC a la lista usando las propiedades leídas
        npcs.append(Npc(propiedades[0], propiedades[1], propiedades[2]))
        
    except:
        # En caso de error, imprimo un mensaje de aviso
        print("Ha ocurrido algún error pero que vamos que no te preocupes")

# Ahora recorro la lista de NPCs y compruebo que se hayan creado correctamente
for npc in npcs:
    # Imprimo las propiedades x, y y ángulo de cada NPC
    print(npc.x, npc.y, npc.angulo)
