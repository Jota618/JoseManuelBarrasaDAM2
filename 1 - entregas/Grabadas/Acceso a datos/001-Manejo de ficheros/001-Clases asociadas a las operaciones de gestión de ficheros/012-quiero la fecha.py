import os
import PIL.Image

lista = os.listdir("fotos")

for archivo in lista:
    print(archivo)
    imagen = PIL.Image.open('fotos/'+archivo)
    datosexif = imagen._getexif()
    cadena = datosexif[306].replace("_","/").replace("0","1") #Recogemos el valor 306, que es la fecha de la foto, y cambiamos los puntos por huecos
    print(cadena)
