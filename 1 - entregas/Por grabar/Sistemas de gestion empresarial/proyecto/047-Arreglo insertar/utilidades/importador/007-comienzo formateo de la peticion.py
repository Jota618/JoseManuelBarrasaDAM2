# pip install pandas                                            # Instalo esta librería para poder leer una gran cantidad de origenes de datos
# pip install openpyxl                                          # Instalo esta librería para poder leer archivos nativos de Office

import pandas as pd                                             # Importo la librería


contenido = pd.read_excel("clientes.xlsx")                      # Leo el contenido del archivo de excel
diccionario = contenido.to_dict()                               # Lo convierto a diccionario de Python

print(diccionario)                                              # Saco el contenido en la pantalla
print(diccionario['nombre'][0])                                 # Compruebo que puedo acceder a cada uno de los datos

peticion = "INSERT INTO clientes VALUES (NULL,"

for clave in diccionario:                                       # Repaso clave a clave el diccionario
    print(clave,diccionario[clave][0])                          # Y saco su contenido por pantalla
    peticion += clave+"='"+str(diccionario[clave][0])+"',"

peticion += ")"

print(peticion)
