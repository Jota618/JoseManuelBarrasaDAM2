import os
import PIL.Image  #Importamos la libreria PIL, para trabajar con imagenes

lista = os.listdir("fotos")

for archivo in lista:
    print(archivo)
    imagen = PIL.Image.open('fotos/'+archivo)  #Abrimos la imagen de la carpeta fotos
    datosexif = imagen._getexif()  #Recogemos los datos de la imagen
    print(datosexif) #Los mostramos en pantalla
