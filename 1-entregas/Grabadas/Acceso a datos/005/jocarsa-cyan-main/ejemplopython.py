#!/usr/bin/env python3
import subprocess
import re
import os

def run_command(command):
    """Ejecuta un comando y muestra su salida o error."""
    result = subprocess.run(command, capture_output=True, text=True)
    if result.returncode != 0:
        print("Error:", result.stderr)
    else:
        print(result.stdout)
    return result

def insert_data(exe_path, database):
    # Solicitar los campos name y age para formar el JSON correctamente
    name = input("Introduce el nombre (name): ")
    age = input("Introduce la edad (age): ")
    try:
        age_int = int(age)
    except ValueError:
        print("La edad debe ser un número entero.")
        return
    json_data = f'{{"name": "{name}", "age": {age_int}}}'
    command = [exe_path, database, "insert", json_data]
    run_command(command)

def update_data(exe_path, database):
    # Listar todos los archivos JSON disponibles en la carpeta para actualizar
    if not os.path.exists(database):
        print(f"La carpeta '{database}' no existe.")
        return
    files = [f for f in os.listdir(database) if f.endswith('.json')]
    if not files:
        print("No se encontraron ficheros JSON en la carpeta", database)
        return
    print("\nFicheros disponibles para actualizar:")
    for i, f in enumerate(files):
        print(f"{i+1}. {f}")
    choice = input("Selecciona el número del fichero que deseas actualizar: ")
    try:
        idx = int(choice) - 1
        if idx < 0 or idx >= len(files):
            print("Número inválido.")
            return
    except ValueError:
        print("Entrada inválida.")
        return
    file_name = files[idx]
    print(f"Has seleccionado: {file_name}")
    
    # Solicitar nuevos datos
    name = input("Introduce el nuevo nombre (name): ")
    age = input("Introduce la nueva edad (age): ")
    try:
        age_int = int(age)
    except ValueError:
        print("La edad debe ser un número entero.")
        return
    json_data = f'{{"name": "{name}", "age": {age_int}}}'
    command = [exe_path, database, "update", file_name, json_data]
    run_command(command)

def delete_data(exe_path, database):
    # Listar todos los archivos JSON disponibles para eliminar
    if not os.path.exists(database):
        print(f"La carpeta '{database}' no existe.")
        return
    
    files = [f for f in os.listdir(database) if f.endswith('.json')]
    if not files:
        print("No se encontraron ficheros JSON en la carpeta", database)
        return
    
    print("\nFicheros disponibles para eliminar:")
    for i, f in enumerate(files):
        print(f"{i+1}. {f}")
    
    choice = input("Selecciona el número del fichero que deseas eliminar: ")
    
    try:
        idx = int(choice) - 1
        if idx < 0 or idx >= len(files):
            print("Número inválido.")
            return
    except ValueError:
        print("Entrada inválida.")
        return
    
    file_name = files[idx]
    command = [exe_path, database, "delete", file_name]
    run_command(command)

def export_data(exe_path, database):
    export_file = input("Introduce el nombre del fichero de exportación (presiona Enter para 'export.json'): ")
    if not export_file:
        export_file = "export.json"
    command = [exe_path, database, "export", export_file]
    run_command(command)

def select_data(exe_path, database):
    command = [exe_path, database, "select"]
    run_command(command)

def extract_json(database):
    # Lista todos los ficheros .json en la carpeta 'database'
    if not os.path.exists(database):
        print(f"La carpeta '{database}' no existe.")
        return
    files = [f for f in os.listdir(database) if f.endswith('.json')]
    if not files:
        print("No se encontraron ficheros JSON en la carpeta", database)
        return
    print("\nFicheros disponibles:")
    for i, f in enumerate(files):
        print(f"{i+1}. {f}")
    choice = input("Selecciona el número del fichero que deseas extraer: ")
    try:
        idx = int(choice) - 1
        if idx < 0 or idx >= len(files):
            print("Número inválido.")
            return
    except ValueError:
        print("Entrada inválida.")
        return
    selected_file = files[idx]
    full_path = os.path.join(database, selected_file)
    try:
        with open(full_path, 'r') as f:
            content = f.read()
        print("\nContenido del fichero seleccionado:")
        print(content)
    except Exception as e:
        print("Error al leer el fichero:", e)

def menu(exe_path, database):
    while True:
        print("\nMenú de operaciones:")
        print("1. Insertar datos")
        print("2. Actualizar datos")
        print("3. Eliminar datos")
        print("4. Exportar datos")
        print("5. Seleccionar (mostrar) todos los datos")
        print("6. Extraer un JSON específico")
        print("0. Salir")
        opcion = input("Elige una opción: ")
        
        if opcion == "1":
            insert_data(exe_path, database)
        elif opcion == "2":
            update_data(exe_path, database)
        elif opcion == "3":
            delete_data(exe_path, database)
        elif opcion == "4":
            export_data(exe_path, database)
        elif opcion == "5":
            select_data(exe_path, database)
        elif opcion == "6":
            extract_json(database)
        elif opcion == "0":
            print("Saliendo del programa...")
            break
        else:
            print("Opción no válida. Intenta de nuevo.")

def main():
    # Ruta del ejecutable (ajusta la ruta según tu entorno)
    exe_path = "/xampp/htdocs/JoseManuelBarrasaDAM2/1 - entregas/Grabadas/Acceso a Datos/005/jocarsa-cyan-main/cyan.exe"
    database = "clientes"
    print("Bienvenido a la interfaz interactiva de la base de datos.")
    menu(exe_path, database)

if __name__ == "__main__":
    main()
