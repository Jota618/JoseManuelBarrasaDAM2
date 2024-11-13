import os
from PIL import Image, ImageOps 

lista = os.listdir("fotos")

for archivo in lista:
    print("ok")
    imagen = Image.open(r"fotos/"+archivo) 
    imagen2 = ImageOps.grayscale(imagen)
    imagen.close()
    imagen2.save('fotos/'+archivo)
    imagen2.close()
