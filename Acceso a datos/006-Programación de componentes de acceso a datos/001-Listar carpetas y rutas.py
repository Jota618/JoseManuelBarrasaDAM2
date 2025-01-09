import os

def listar_estructura(ruta, archivo_salida):
    with open(archivo_salida, 'w', encoding='utf-8') as f:
        for root, dirs, files in os.walk(ruta):
            # Calcular el nivel de profundidad
            relative_path = os.path.relpath(root, ruta)
            if relative_path == '.':
                level = 0
            else:
                level = relative_path.count(os.sep) + 1
            indent = '    ' * level  # 4 espacios por nivel de indentación
            
            # Escribir el nombre de la carpeta
            carpeta = os.path.basename(root)
            if carpeta:  # Evitar escribir una línea vacía para la ruta raíz si es necesario
                f.write(f"{indent}{carpeta}/\n")
            
            # Escribir los archivos dentro de la carpeta
            for file in files:
                file_indent = '    ' * (level + 1)
                f.write(f"{file_indent}{file}\n")

# Llamar a la función para listar la estructura de tu proyecto
carpeta = input("Indica la carpeta sobre la cual sacar la estructura: ")
listar_estructura(carpeta, 'estructura_proyecto.txt')
print("La estructura del proyecto ha sido guardada en 'estructura_proyecto.txt'.")
