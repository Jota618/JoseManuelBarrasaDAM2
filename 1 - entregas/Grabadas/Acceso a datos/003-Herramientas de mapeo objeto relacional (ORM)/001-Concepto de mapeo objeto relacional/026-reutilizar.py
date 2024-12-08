import mysql.connector  # Importa el conector de MySQL para gestionar la base de datos

###################################### CREO UNA CLASE QUE ES EL MODELO DE DATOS
class Producto:
    def __init__(self, nuevonombre, nuevadescripcion, nuevoprecio, nuevascalidades, nuevascategorias):
        # Constructor de la clase Producto, que inicializa sus atributos
        self.nombre = nuevonombre
        self.descripcion = nuevadescripcion
        self.precio = nuevoprecio
        self.categorias = nuevascategorias  # Lista de categorías
        self.calidad = nuevascalidades  # Calidad del producto

clase = "Producto"  # Nombre de la tabla en la base de datos

##################################### PREPARO UNA CONEXIÓN CON EL SERVIDOR
conexion = mysql.connector.connect(
    host='localhost',  # Dirección del servidor
    database='accesoadatos',  # Nombre de la base de datos
    user='accesoadatos',  # Usuario de la base de datos
    password='accesoadatos'  # Contraseña del usuario
)
cursor = conexion.cursor()  # Objeto cursor para ejecutar consultas

##################################### CREO UNA LISTA DE PRODUCTOS
personas = []  # Lista donde se almacenarán objetos Producto

# Añadimos productos a la lista
personas.append(Producto("Camiseta", "Camiseta fenomenal para el dia a dia", 35.99, "basic", ['ropa', 'caballero']))
personas.append(Producto("Pantalon", "Pantalon para vestir de noche", 55.99, "basic", ['ropa', 'señora']))
personas.append(Producto("Abrigo", "Abrigo elegante", 69.99, "premium", ['ropa', 'unisex']))
personas.append(Producto("Abrigo", "Abrigo elegante femenino", 59.99, "basic", ['ropa', 'señora']))
personas.append(Producto("Abrigo", "Abrigo elegante masculino", 59.99, "basic", ['ropa', 'caballero']))
personas.append(Producto("Guantes", "Guantes de vestir", 24.99, "premium", ['ropa', 'unisex']))
personas.append(Producto("Sombrero", "Sombrero elegante", 29.99, "premium", ['ropa', 'unisex']))

##################################### BORRAMOS LA TABLA ANTERIOR POR SI ACASO HAY DATOS ANTERIOR
peticion = "DROP TABLE IF EXISTS " + clase  # Consulta para eliminar la tabla si existe
cursor.execute(peticion)

##################################### CREACIÓN DINÁMICA DE LA TABLA EN LA BASE DE DATOS
peticion = "CREATE TABLE IF NOT EXISTS " + clase + " (Identificador INT NOT NULL AUTO_INCREMENT,"  # Creación inicial
atributos = [attr for attr in dir(personas[0]) if not callable(getattr(personas[0], attr)) and not attr.startswith("__")]  # Atributos no mágicos de la clase Producto

# Añadimos los atributos a la tabla
for atributo in atributos:
    if not isinstance(getattr(personas[0], atributo), list):
        peticion += atributo + " VARCHAR(255) NOT NULL ,"  # Atributos simples como columnas
    else:
        # Gestión de atributos que son listas
        peticion2 = "DROP TABLE IF EXISTS " + atributo
        cursor.execute(peticion2)
        peticion2 = f"CREATE TABLE IF NOT EXISTS {atributo} (Identificador INT NOT NULL AUTO_INCREMENT, FK INT(255), {atributo} VARCHAR(255), PRIMARY KEY (Identificador))"
        cursor.execute(peticion2)

peticion += " PRIMARY KEY (Identificador))"  # Cerramos la creación de la tabla
print(peticion)
cursor.execute(peticion)  # Ejecutamos la consulta

##################################### INSERCIÓN DINÁMICA DE REGISTROS EN LA BASE DE DATOS
for indice, persona in enumerate(personas):
    peticion = "INSERT INTO " + clase + " VALUES(NULL,"  # Preparamos la inserción inicial

    for atributo in atributos:
        if not isinstance(getattr(persona, atributo), list):
            peticion += "'" + str(getattr(persona, atributo)) + "',"  # Añadimos valores simples
        else:
            for elemento in getattr(persona, atributo):  # Gestionamos listas
                peticion2 = f"INSERT INTO {atributo} VALUES(NULL, {indice + 1}, '{elemento}')"
                cursor.execute(peticion2)
    peticion = peticion[:-1]  # Eliminamos la última coma
    peticion += ");"
    cursor.execute(peticion)  # Ejecutamos la inserción

conexion.commit()  # Aplicamos todos los cambios en la base de datos

##################   CONSULTA DE PRODUCTOS
def consultar_productos_por_atributo(atributo, valor):
    """
    Consulta productos en la base de datos filtrando por un atributo específico.
    """
    query = f"SELECT * FROM Producto WHERE {atributo} = %s"
    cursor.execute(query, (valor,))
    resultados = cursor.fetchall()
    for fila in resultados:
        print(fila)

# Ejemplo de consultas
consultar_productos_por_atributo('nombre', 'Camiseta')
consultar_productos_por_atributo('calidad', 'basic')

############## ACTUALIZAR PRODUCTOS
def actualizar_producto(id_producto, **kwargs):
    """Actualiza uno o más atributos de un producto en la base de datos.kwargs puede incluir: nombre, descripcion, precio, calidad, etc."""
    set_clause = ", ".join(f"{key} = %s" for key in kwargs)  # Construimos la cláusula SET
    valores = tuple(kwargs.values()) + (id_producto,)  # Incluimos los valores y el ID
    query = f"UPDATE Producto SET {set_clause} WHERE Identificador = %s"
    cursor.execute(query, valores)
    conexion.commit()
    print(f"Producto con ID {id_producto} actualizado.")

# Ejemplo de actualización (comentado)
# actualizar_producto(2, nombre="Pantalón", precio=61.99)
