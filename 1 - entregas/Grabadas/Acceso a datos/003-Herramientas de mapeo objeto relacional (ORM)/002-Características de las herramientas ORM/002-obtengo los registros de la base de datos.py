import mysql.connector
###################################### CREO UNA CLASE QUE ES EL MODELO DE DATOS
class Producto:
    def __init__(self,
                    nuevonombre,
                    nuevadescripcion,
                    nuevoprecio,
                     nuevascategorias):
        self.nombre = nuevonombre
        self.descripcion = nuevadescripcion
        self.precio = nuevoprecio
        self.categorias =  nuevascategorias
clase = "Producto"

##################################### PREPARO UNA CONEXIÓN CON EL SERVIDOR

conexion = mysql.connector.connect(
            host='localhost',  
            database='accesoadatos', 
            user='accesoadatos',  
            password='accesoadatos'  
        )

cursor = conexion.cursor(dictionary=True) 

##################################### CREO UNA LISTA DE PRODUCTOS DE LA BASE DE DATOS

peticion = "SELECT * FROM "+clase
cursor.execute(peticion)

filas = cursor.fetchall()
for fila in filas:
    print(fila)

personas = []
conexion.commit()                                                                       # Lo lanzo todo contra el servidor


















