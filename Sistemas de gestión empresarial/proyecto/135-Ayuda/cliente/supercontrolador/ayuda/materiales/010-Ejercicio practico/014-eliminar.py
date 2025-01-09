"""
    Tienda de ropa
    (c) 2024 Jose Vicente Carratalá
"""
# Condiciones iniciales

productos = []

# Mensaje de bienvenida

print("######## Bienvenidos ########")
print("#### A la tienda de ropa ####")
print("# de Jose Vicente Carratalá #")
print("")

# Menú principal
while True:
    print("Menú:")
    print("1.-Insertar un producto")
    print("2.-Listar productos")
    print("3.-Actualizar un producto")
    print("4.-Eliminar un producto")
    print("")

    # Selección de opción

    opcion = input("Selecciona una opción(1-4):")
    print(f"Has escogido la opcion: {opcion}")

    # Comportamiento condicional

    if opcion == "1":
        print("Vamos a insertar un registro")
        nombre = input("Nombre:")
        descripcion = input("Descripcion:")
        precio = input("Precio:")
        productos.append(
                {
                    "nombre":nombre,
                    "descripcion":descripcion,
                    "precio":precio
                }
            )
    elif opcion == "2":
        print("Vamos a listar los registros")
        for producto in productos:
            print(producto)
    elif opcion == "3":
        print("Vamos a actualizar un registro")
        identificador = input("Selecciona el id")
        nombre = input("Nombre:")
        descripcion = input("Descripcion:")
        precio = input("Precio:")
        productos[identificador]['nombre'] = nombre
        productos[identificador]['descripcion'] = descripcion
        productos[identificador]['precio'] = precio
    elif opcion == "4":
        print("Vamos a eliminar un registro")
        identificador = input("Selecciona el id")
        productos.pop(identificador)







