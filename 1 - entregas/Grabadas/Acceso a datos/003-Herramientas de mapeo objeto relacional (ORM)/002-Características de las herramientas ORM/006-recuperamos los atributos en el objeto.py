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

productos = []                                                                                      # Creo una lista vacia

peticion = "SELECT * FROM "+clase                                                                   # Selecciono todos los elementos de la clase
cursor.execute(peticion)                                                                            # Ejecuto la peticion

filas = cursor.fetchall()                                                                           # REcupero las filas
for fila in filas:                                                                                  # Para cada fila
    producto = Producto()                                                                           # Creo un nuevo producto
    for clave, valor in fila.items():                                                               # PAra cada una de las claves
        setattr(producto, clave, valor)                                                             # Le pongo la clave en el producto

    # Ahora busco si hay tablas externas
    for clave, valor in vars(producto).items():                                                     # Para cada uno de los atributos de producto
        if valor == None:                                                                           # Si su valor es None es que debe ser tabla externa
            setattr(producto, clave, [])                                                            # Le cambio none por una lista vacia
            print("parece que hay una tabla externa en :",clave)                        
            peticion2 = "SELECT "+clave+" FROM "+clave+" WHERE FK = "+str(producto.Identificador)   # Realizo una peticion a esa otra tabla
            cursor.execute(peticion2)                                                               # Ejecuto la peticion
            filas2 = cursor.fetchall()                                                              # recupero los datos
            for fila2 in filas2:                                                                    # Itero los datos
                print(fila2)                                                                        # Imprimo la fila
                # append to property here as a list
                getattr(producto, clave).append(fila2[clave])                                       # Le añado a la lista los elementos de esa otra tabla
    productos.append(producto)                                                                      # Añado el producto a la lista 

print(vars(productos[0]))
    
    

personas = []
conexion.commit()                                                                       # Lo lanzo todo contra el servidor


















