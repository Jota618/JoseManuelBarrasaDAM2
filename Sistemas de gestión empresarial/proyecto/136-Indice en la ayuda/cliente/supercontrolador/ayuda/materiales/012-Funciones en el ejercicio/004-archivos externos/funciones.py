
# Declaración de funciones

def bienvenida():
    # Mensaje de bienvenida
    print("######## Bienvenidos ########")
    print("#### A la tienda de ropa ####")
    print("# de Jose Vicente Carratalá #")
    print("")

def menu():
    # Menú principal
    print("Menú:")
    print("1.-Insertar un producto")
    print("2.-Listar productos")
    print("3.-Actualizar un producto")
    print("4.-Eliminar un producto")
    print("")

def insertar():
    print("Vamos a insertar un registro")
    # Le pedimos al usuario los datos
    nombre = input("Nombre:")
    descripcion = input("Descripcion:")
    precio = input("Precio:")
    # Añdimos un nuevo elemento a la lista
    productos.append(
            {
                "nombre":nombre,
                "descripcion":descripcion,
                "precio":precio
            }
        )
def listar():
     print("Vamos a listar los registros")
    # Listamos cada producto en productos
    for producto in productos:
        print(producto)

def actualizar():
    print("Vamos a actualizar un registro")
    # Solicitamos un id
    identificador = int(input("Selecciona el id"))
    # Solicitamos nuevos datos
    nombre = input("Nombre:")
    descripcion = input("Descripcion:")
    precio = input("Precio:")
    # Actualizamos
    productos[identificador]['nombre'] = nombre
    productos[identificador]['descripcion'] = descripcion
    productos[identificador]['precio'] = precio
def eliminar():
    print("Vamos a eliminar un registro")
    # Solicitamos un id
    identificador = input("Selecciona el id")
    # Boramos el registro concreto
    productos.pop(identificador)
# Condiciones iniciales

productos = []






