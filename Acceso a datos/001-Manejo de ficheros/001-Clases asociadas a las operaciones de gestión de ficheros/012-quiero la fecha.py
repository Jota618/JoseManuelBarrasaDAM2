import os
import PIL.Image

lista = os.listdir("fotos")

for archivo in lista:
    print(archivo)
    imagen = PIL.Image.open('fotos/'+archivo)
    datosexif = imagen._getexif()
    cadena = datosexif[306].replace(":","").replace(" ","")
    print(cadena)
