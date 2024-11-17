import csv                                      # Importo librería para trabajar con CSV

diccionario = {}                                # Creo un diccionario
archivo = open('mapeado.csv', mode='r')         # Abro el csv en modo lectura
lectorcsv = csv.DictReader(archivo)             # Cargo sobre el diccionario el contenido del csv

mapeado = []                                    # Creo una lista vacía

for fila in lectorcsv:                          # Para cada una de las filas del csv
    mapeado.append(fila)                        # Añado el diccionario a la lista

print(mapeado)                                  # Lo imprimo para comprobar que todo va bien
