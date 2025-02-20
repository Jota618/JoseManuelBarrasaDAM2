import json  # Importo la librería para trabajar con archivos JSON
import xml  # Importo la librería para trabajar con XML (no se usa en este fragmento)

# Abro el archivo cliente.json en modo lectura
with open('cliente.json', 'r') as archivo:  
    datos = json.load(archivo)  # Cargo el contenido del archivo JSON en la variable datos

print(datos)  # Imprimo los datos cargados en la consola