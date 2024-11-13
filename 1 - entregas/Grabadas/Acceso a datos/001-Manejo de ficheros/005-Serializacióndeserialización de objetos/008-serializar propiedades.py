import random  # Importo el módulo random para generar números aleatorios
import math  # Importo el módulo math para usar funciones matemáticas

class Npc:  # Declaro una clase Npc
    def __init__(self):
        self.x = random.randint(0, 512)  # Genera una coordenada x aleatoria entre 0 y 512
        self.y = random.randint(0, 512)  # Genera una coordenada y aleatoria entre 0 y 512
        self.angulo = random.random() * math.pi * 2  # Genera un ángulo aleatorio entre 0 y 2π

npcs = []  # Creo una lista vacía para almacenar los NPCs
numero = 10  # Defino el número de NPCs que quiero crear

for i in range(0, numero):  # Recorro la lista en un rango de 0 a 10
    npcs.append(Npc())  # Añado una instancia de la clase Npc a la lista

cadena = ""  # Inicializo una cadena vacía

for i in range(0, numero):  # Recorro la lista de NPCs
    cadena += str(npcs[i].x) + "," + str(npcs[i].y) + "," + str(npcs[i].angulo) + "|"  # Concateno x, y, y ángulo de cada NPC en la cadena, separados por comas

print(cadena)  # Imprimo la cadena para verificar el resultado

mibasededatos = open("basededatos.txt", 'w')  # Abro un archivo "basededatos.txt" en modo escritura ('w')
mibasededatos.write(cadena)  # Escribo la cadena generada en el archivo
mibasededatos.close()  # Cierro el archivo para guardar los cambios
