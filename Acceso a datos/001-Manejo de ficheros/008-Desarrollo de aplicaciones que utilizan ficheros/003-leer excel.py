import pandas as pd

df = pd.read_excel('clientes.ods', engine='odf')

print(df.head())


ruta = 'clientesdesdeexcel.json'
df.to_json(ruta, orient='records', lines=True)
