# pip install pandas                                                # Instalo esta librería para poder leer una gran cantidad de origenes de datos
# pip install openpyxl                                              # Instalo esta librería para poder leer archivos nativos de Office

import pandas as pd                                                 # Importo la librería
import mysql.connector                                              # Importo conector de MySQL

conexion = mysql.connector.connect(
            host="localhost",
            database="crimson",
            user="crimson",
            password="crimson"
        )                                                           # Me conecto a la base de datos

cursor = conexion.cursor()                                          # Creo un cursor

contenido = pd.read_excel("clientes.xlsx")                          # Leo el contenido del archivo de excel
diccionario = contenido.to_dict()                                   # Lo convierto a diccionario de Python

print(diccionario)                                                  # Saco el contenido en la pantalla
print(diccionario['nombre'][0])                                     # Compruebo que puedo acceder a cada uno de los datos

for i in range(0,2):

    peticion = 'INSERT INTO clientes VALUES (NULL,'                 # Creo el inicio de una petición de insert

    for clave in diccionario:                                       # Repaso clave a clave el diccionario
        print(clave,diccionario[clave][i])                          # Y saco su contenido por pantalla
        peticion += '"'+str(diccionario[clave][i])+'",'             # Le añado al insert cada uno de los campos del diccionario
    peticion = peticion[:-1]                                        # Le quito el último caracter

    peticion += ')'                                                 # Cierro con el parentesis

    print(peticion)                                                 # Imprimo la petición
    cursor.execute(peticion)                                        # ejecuto la petición
    conexion.commit()                                               # Lanzo la peticion
