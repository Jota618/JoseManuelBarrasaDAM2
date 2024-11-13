import os
import PIL.Image

lista = os.listdir("fotos")

for archivo in lista:
    print(archivo)
    imagen = PIL.Image.open('fotos/'+archivo)
    datosexif = imagen._getexif()
    cadena = datosexif[306].replace(":","-").replace(" ","_")
    print(cadena)
    os.rename('fotos/'+archivo,'fotos/'+cadena+".jpg") #Cambiamos el nombre de cada imagen por la fecha de creacion de cada imagen