import random
import math
# Declaro una clase Npc y le pongo dos sencillas propiedades x e y
class Npc:
    def __init__(self):
        self.x = random.randint(0,512)
        self.y = random.randint(0,512)
        self.angulo = random.random()*math.pi*2 #Añadimos el angulo an npc
# Creo una lista de 10 npcs
npcs = []
numero = 10
# Recorro la lista y a cada elemento le meto una instancia de la clase Npc
for i in range(0,numero):
    npcs.append(Npc())

for i in range(0,numero):
    print(npcs[i].x,npcs[i].y,npcs[i].angulo) #Mostramos en pantalla al npc


