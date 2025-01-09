from Producto import *

# Condiciones iniciales

productos = []
import json
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
    print("5.-Guardar productos")
    print("6.-Cargar productos")
    print("7.-Salir")
    print("")

def insertar():
    print("Vamos a insertar un registro")
    # Le pedimos al usuario los datos
    nombre = input("Nombre:")
    descripcion = input("Descripcion:")
    precio = input("Precio:")
    # Añdimos un nuevo elemento a la lista
    productos.append(
        Producto(nombre,
                descripcion,
                precio)
        )
def listar():
    print("Vamos a listar los registros")
    # Listamos cada producto en productos
    for producto in productos:
        print(producto.getNombre())
        print(producto.getDescripcion())
        print(producto.getPrecio())

def actualizar():
    print("Vamos a actualizar un registro")
    # Solicitamos un id
    identificador = int(input("Selecciona el id"))
    # Solicitamos nuevos datos
    precio = input("Precio:")
    # Actualizamos
    productos[identificador].setPrecio(precio)
def eliminar():
    print("Vamos a eliminar un registro")
    # Solicitamos un id
    identificador = input("Selecciona el id")
    # Boramos el registro concreto
    productos.pop(identificador)

def guardar():
    archivo = open("agenda.json","w")
    productos_dict = [producto.__dict__ for producto in productos]
    json.dump(productos_dict,archivo,indent=4)
    archivo.close()
    
def cargar():
    global productos
    archivo = open("agenda.json","r")
    
    datos = json.load(archivo)
    for producto in datos:
        productos.append(
            Producto(
                producto['nombre'],
                producto['descripcion'],
                producto['precio'])
            )
    
def salir():
    exit()
    





