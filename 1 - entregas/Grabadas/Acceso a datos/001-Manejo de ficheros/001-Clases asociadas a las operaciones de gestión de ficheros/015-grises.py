import os
from PIL import Image, ImageOps 

lista = os.listdir("fotos")

for archivo in lista:
    print("ok")
    imagen = Image.open(r"fotos/"+archivo) #Abrimos cada imagen
    imagen2 = ImageOps.grayscale(imagen) #Aplicamos una escala de grises
    imagen.close() #Cerramos el proceso de abrir las imagenes
    imagen2.save('fotos/'+archivo) #Guardamos los cambios
    imagen2.close() #Cerramos el proceso de la escala de grises