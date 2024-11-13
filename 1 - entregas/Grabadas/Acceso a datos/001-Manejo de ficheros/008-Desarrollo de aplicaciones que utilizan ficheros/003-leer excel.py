import pandas as pd  # Importo la biblioteca pandas para manipulación de datos

# Leo el archivo ODS y lo guardo en un DataFrame
df = pd.read_excel('clientes.ods', engine='odf')  

print(df.head())  # Imprimo las primeras filas del DataFrame para visualizar los datos

ruta = 'clientesdesdeexcel.json'  # Defino la ruta donde se guardará el archivo JSON
df.to_json(ruta, orient='records', lines=True)  # Convierto el DataFrame a formato JSON y lo guardo en el archivo especificado