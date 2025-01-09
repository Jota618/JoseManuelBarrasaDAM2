from funciones import *
"""
    Tienda de ropa
    (c) 2024 Jose Vicente Carratalá
"""

# Programa

bienvenida()
while True:
    menu()
    opcion = input("Selecciona una opción(1-4):")
    print(f"Has escogido la opcion: {opcion}")
    if opcion == "1":
        insertar()
    elif opcion == "2":
        listar()
    elif opcion == "3":
        actualizar()
    elif opcion == "4":
        eliminar()







