import mysql.connector
###################################### CREO UNA CLASE QUE ES EL MODELO DE DATOS
class Producto:
    def __init__(self):
        self.nombre = None
        self.descripcion = None
        self.precio = None
        self.categorias =  None
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

productos = []

peticion = "SELECT * FROM "+clase
cursor.execute(peticion)

filas = cursor.fetchall()
for fila in filas:
    producto = Producto()
    for clave, valor in fila.items():
        setattr(producto, clave, valor) 
    productos.append(producto)
    # Ahora busco si hay tablas externas
    for clave, valor in vars(producto).items():
        if valor == None:
            print("parece que hay una tabla externa en :",clave)
            peticion2 = "SELECT "+clave+" FROM "+clave+" WHERE FK = "+str(producto.Identificador)
            cursor.execute(peticion2)
            filas2 = cursor.fetchall()
            for fila2 in filas2:
                print(fila2)
    

print(vars(productos[0]))
    
    

personas = []
conexion.commit()                                                                       # Lo lanzo todo contra el servidor


















