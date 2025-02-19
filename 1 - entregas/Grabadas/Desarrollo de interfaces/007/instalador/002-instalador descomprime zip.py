import zipfile
import os

archivo_original = "paquete.zip"
salida = "descomprimido"

comprimido = zipfile.ZipFile(archivo_original,'r')
comprimido.extractall(salida)
