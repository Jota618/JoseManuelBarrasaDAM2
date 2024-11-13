# pip install pandas
# pip install openpyxl

import pandas as pd


contenido = pd.read_excel("clientes.xlsx")
diccionario = contenido.to_dict()

print(diccionario)
print(diccionario['nombre'][0])

for clave in diccionario:
    print(clave,diccionario[clave][0])
