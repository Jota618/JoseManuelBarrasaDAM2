import os
import re

def listar_estructura_markdown(ruta, archivo_salida):
    """
    Genera la estructura del directorio en formato Markdown con listas desordenadas.

    Args:
        ruta (str): Ruta de la carpeta a analizar.
        archivo_salida (str): Nombre del archivo Markdown de salida.
    """
    with open(archivo_salida, 'w', encoding='utf-8') as f:
        f.write("# Estructura del Proyecto\n\n")
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
                f.write(f"{indent}- **{carpeta}/**\n")

            # Escribir los archivos dentro de la carpeta
            for file in files:
                file_indent = '    ' * (level + 1)
                f.write(f"{file_indent}- {file}\n")


def extraer_docstring(file_path):
    """
    Extrae el docstring o comentarios iniciales de un archivo según su tipo.

    Args:
        file_path (str): Ruta completa del archivo.

    Returns:
        str: Contenido del docstring/comentario si se encuentra, de lo contrario, una cadena vacía.
    """
    _, ext = os.path.splitext(file_path)
    ext = ext.lower()
    doc = ""

    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        if ext == '.py':
            # Extraer cadenas triple comillas al inicio del archivo
            match = re.match(r'^\s*(?:\'\'\'|\"\"\")([\s\S]*?)(?:\'\'\'|\"\"\")', content, re.DOTALL)
            if match:
                doc = match.group(1).strip()
            else:
                # Intentar extraer comentarios de una línea al inicio
                comments = []
                for line in content.splitlines():
                    line = line.strip()
                    if line.startswith("#"):
                        comments.append(line.lstrip("#").strip())
                    elif not line:
                        continue
                    else:
                        break
                if comments:
                    doc = "\n".join(comments)
        elif ext in ['.js', '.php', '.css']:
            # Extraer comentarios multilínea /* */ al inicio del archivo
            multiline_match = re.match(r'^\s*/\*([\s\S]*?)\*/', content, re.DOTALL)
            if multiline_match:
                doc = multiline_match.group(1).strip()
            else:
                # Extraer comentarios de una línea // al inicio del archivo
                comments = []
                for line in content.splitlines():
                    line = line.strip()
                    if line.startswith("//"):
                        comments.append(line.lstrip("//").strip())
                    elif not line:
                        continue
                    else:
                        break
                if comments:
                    doc = "\n".join(comments)
        elif ext == '.html':
            # Extraer comentarios <!-- --> al inicio del archivo
            match = re.match(r'^\s*<!--([\s\S]*?)-->', content, re.DOTALL)
            if match:
                doc = match.group(1).strip()
        else:
            # Tipos de archivo no soportados
            pass

    except Exception as e:
        print(f"Error al procesar el archivo {file_path}: {e}")

    return doc


def agregar_docstrings_markdown(ruta, archivo_salida):
    """
    Agrega docstrings/comentarios de los archivos al documento Markdown.

    Args:
        ruta (str): Ruta de la carpeta a analizar.
        archivo_salida (str): Nombre del archivo Markdown de salida.
    """
    with open(archivo_salida, 'a', encoding='utf-8') as f:
        f.write("\n# Documentación de Archivos\n\n")
        for root, dirs, files in os.walk(ruta):
            for file in files:
                file_path = os.path.join(root, file)
                doc = extraer_docstring(file_path)
                if doc:
                    # Crear una ruta relativa para el encabezado
                    relative_path = os.path.relpath(file_path, ruta)
                    f.write(f"## {relative_path}\n\n")
                    f.write(f"{doc}\n\n")


def main():
    """
    Función principal que ejecuta las dos fases: generación de estructura y extracción de docstrings.
    """
    carpeta = input("Indica la carpeta sobre la cual sacar la estructura: ").strip()
    if not os.path.isdir(carpeta):
        print(f"La ruta especificada '{carpeta}' no es una carpeta válida.")
        return

    archivo_md = 'estructura_proyecto.md'
    listar_estructura_markdown(carpeta, archivo_md)
    print(f"La estructura del proyecto ha sido guardada en '{archivo_md}'.")

    # Fase 2: Agregar docstrings
    agregar_docstrings_markdown(carpeta, archivo_md)
    print(f"Las docstrings/comentarios han sido agregados al archivo '{archivo_md}'.")


if __name__ == "__main__":
    main()
