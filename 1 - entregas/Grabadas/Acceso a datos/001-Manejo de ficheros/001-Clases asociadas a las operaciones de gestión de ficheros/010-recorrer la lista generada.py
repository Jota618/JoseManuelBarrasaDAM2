import os

lista = os.listdir("fotos")

for archivo in lista: #Mediante un bucle for, recorremos la lista por cada archivo
    print(archivo) #Mostramos cada archivo
