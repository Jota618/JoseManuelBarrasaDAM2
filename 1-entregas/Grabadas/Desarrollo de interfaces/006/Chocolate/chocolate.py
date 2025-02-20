import os
import sys
import json
import shutil
import subprocess
import threading
from datetime import datetime
from tkinter import Tk, StringVar, BooleanVar, filedialog
from ttkbootstrap import ttk, Style
from ttkbootstrap.constants import *

# -------------------------------
# Funciones comunes y de utilidad
# -------------------------------

def filtrar_directorios(dirs):
    """Elimina de la lista los directorios que comienzan con un punto."""
    dirs[:] = [d for d in dirs if not d.startswith('.')]

def obtener_metadatos_archivo(file_path):
    """Obtiene tamaño y fecha de última modificación de un archivo."""
    try:
        stats = os.stat(file_path)
        size = stats.st_size
        mod_time = datetime.fromtimestamp(stats.st_mtime).strftime("%Y-%m-%d %H:%M:%S")
        return f" (tamaño: {size} bytes, modificado: {mod_time})"
    except Exception as e:
        return ""

def contar_items(ruta):
    """
    Cuenta el total de items (directorios y archivos) a procesar, ignorando ocultos.
    Esta función se usará para la actualización de la barra de progreso.
    """
    total = 0
    for root, dirs, files in os.walk(ruta):
        filtrar_directorios(dirs)
        total += 1  # Directorio actual
        total += len([file for file in files if not file.startswith('.')])
    return total

def abrir_archivo(file_path):
    """Abre el archivo generado usando la aplicación predeterminada del sistema."""
    try:
        if sys.platform.startswith('win'):
            os.startfile(file_path)
        elif sys.platform.startswith('darwin'):
            subprocess.call(('open', file_path))
        else:
            subprocess.call(('xdg-open', file_path))
    except Exception as e:
        print(f"Error al abrir el archivo: {e}")

# -------------------------------
# Funciones para exportar la estructura en distintos formatos
# -------------------------------

def listar_estructura_md(ruta, archivo_salida, mostrar_metadatos=False, update_progress=None, total_items=0):
    """Genera un archivo Markdown con la estructura del directorio."""
    processed = 0
    with open(archivo_salida, 'w', encoding='utf-8') as f:
        f.write("# Estructura del Proyecto\n\n")
        for root, dirs, files in os.walk(ruta):
            filtrar_directorios(dirs)
            relative_path = os.path.relpath(root, ruta)
            level = 0 if relative_path == '.' else relative_path.count(os.sep) + 1
            indent = '    ' * level
            carpeta = os.path.basename(root)
            if carpeta:
                f.write(f"{indent}- **🗀  {carpeta}/**\n")
            processed += 1
            if update_progress:
                update_progress(processed, total_items)
            for file in files:
                if not file.startswith('.'):
                    file_indent = '    ' * (level + 1)
                    metadata = ""
                    if mostrar_metadatos:
                        file_full_path = os.path.join(root, file)
                        metadata = obtener_metadatos_archivo(file_full_path)
                    f.write(f"{file_indent}- 🗋  {file}{metadata}\n")
                    processed += 1
                    if update_progress:
                        update_progress(processed, total_items)

def listar_estructura_txt(ruta, archivo_salida, mostrar_metadatos=False, update_progress=None, total_items=0):
    """Genera un archivo TXT con la estructura del directorio (formato simple)."""
    processed = 0
    with open(archivo_salida, 'w', encoding='utf-8') as f:
        f.write("Estructura del Proyecto\n\n")
        for root, dirs, files in os.walk(ruta):
            filtrar_directorios(dirs)
            relative_path = os.path.relpath(root, ruta)
            level = 0 if relative_path == '.' else relative_path.count(os.sep) + 1
            indent = '    ' * level
            carpeta = os.path.basename(root)
            if carpeta:
                f.write(f"{indent}[DIR] {carpeta}/\n")
            processed += 1
            if update_progress:
                update_progress(processed, total_items)
            for file in files:
                if not file.startswith('.'):
                    file_indent = '    ' * (level + 1)
                    metadata = ""
                    if mostrar_metadatos:
                        file_full_path = os.path.join(root, file)
                        metadata = obtener_metadatos_archivo(file_full_path)
                    f.write(f"{file_indent}[FILE] {file}{metadata}\n")
                    processed += 1
                    if update_progress:
                        update_progress(processed, total_items)

def build_structure(path, mostrar_metadatos, update_progress, processed_counter, total_items):
    """
    Función recursiva para construir la estructura en formato de diccionario,
    que luego se exportará a JSON.
    """
    structure = {"name": os.path.basename(path) or path, "files": [], "subdirs": []}
    processed_counter[0] += 1
    if update_progress:
        update_progress(processed_counter[0], total_items)
    try:
        entries = sorted(os.listdir(path))
    except Exception as e:
        entries = []
    for entry in entries:
        if entry.startswith('.'):
            continue
        full_path = os.path.join(path, entry)
        if os.path.isdir(full_path):
            sub_structure = build_structure(full_path, mostrar_metadatos, update_progress, processed_counter, total_items)
            structure["subdirs"].append(sub_structure)
        else:
            metadata = ""
            if mostrar_metadatos:
                metadata = obtener_metadatos_archivo(full_path)
            structure["files"].append({"name": entry, "metadata": metadata})
            processed_counter[0] += 1
            if update_progress:
                update_progress(processed_counter[0], total_items)
    return structure

def listar_estructura_json(ruta, archivo_salida, mostrar_metadatos=False, update_progress=None, total_items=0):
    """Genera un archivo JSON con la estructura del directorio."""
    processed_counter = [0]
    structure = build_structure(ruta, mostrar_metadatos, update_progress, processed_counter, total_items)
    with open(archivo_salida, 'w', encoding='utf-8') as f:
        json.dump(structure, f, indent=4, ensure_ascii=False)

def build_html_structure(path, mostrar_metadatos, update_progress, processed_counter, total_items):
    """
    Función recursiva para construir la estructura en formato HTML.
    Retorna una cadena HTML con una lista anidada.
    """
    name = os.path.basename(path) or path
    html = f"<li><strong>{name}/</strong>"
    processed_counter[0] += 1
    if update_progress:
        update_progress(processed_counter[0], total_items)
    try:
        entries = sorted(os.listdir(path))
    except Exception as e:
        entries = []
    sub_items = ""
    for entry in entries:
        if entry.startswith('.'):
            continue
        full_path = os.path.join(path, entry)
        if os.path.isdir(full_path):
            sub_items += build_html_structure(full_path, mostrar_metadatos, update_progress, processed_counter, total_items)
        else:
            metadata = ""
            if mostrar_metadatos:
                metadata = obtener_metadatos_archivo(full_path)
            sub_items += f"<li>{entry}{metadata}</li>"
            processed_counter[0] += 1
            if update_progress:
                update_progress(processed_counter[0], total_items)
    if sub_items:
        html += f"<ul>{sub_items}</ul>"
    html += "</li>"
    return html

def listar_estructura_html(ruta, archivo_salida, mostrar_metadatos=False, update_progress=None, total_items=0):
    """Genera un archivo HTML con la estructura del directorio."""
    processed_counter = [0]
    html_structure = (
        "<html><head><meta charset='utf-8'><title>Estructura del Proyecto</title></head>"
        "<body><h1>Estructura del Proyecto</h1><ul>"
    )
    html_structure += build_html_structure(ruta, mostrar_metadatos, update_progress, processed_counter, total_items)
    html_structure += "</ul></body></html>"
    with open(archivo_salida, 'w', encoding='utf-8') as f:
        f.write(html_structure)

def listar_estructura(ruta, archivo_salida, formato, mostrar_metadatos, update_progress, total_items):
    """
    Función genérica que llama a la función de exportación según el formato elegido.
    """
    formato = formato.lower()
    if formato == "markdown":
        listar_estructura_md(ruta, archivo_salida, mostrar_metadatos, update_progress, total_items)
    elif formato == "txt":
        listar_estructura_txt(ruta, archivo_salida, mostrar_metadatos, update_progress, total_items)
    elif formato == "json":
        listar_estructura_json(ruta, archivo_salida, mostrar_metadatos, update_progress, total_items)
    elif formato == "html":
        listar_estructura_html(ruta, archivo_salida, mostrar_metadatos, update_progress, total_items)
    else:
        listar_estructura_md(ruta, archivo_salida, mostrar_metadatos, update_progress, total_items)

# -------------------------------
# Funciones del proceso principal y de exportación ZIP
# -------------------------------

def procesar(carpeta, archivo_salida, formato, mostrar_metadatos, actualizar_label, update_progress):
    """
    Ejecuta el proceso de generación de la estructura en el formato seleccionado,
    actualiza la barra de progreso y abre el archivo generado.
    """
    try:
        total_items = contar_items(carpeta)
        listar_estructura(carpeta, archivo_salida, formato, mostrar_metadatos, update_progress, total_items)
        actualizar_label("Estructura del proyecto generada.")
        if update_progress:
            update_progress(total_items, total_items)
        actualizar_label(f"Proceso completado. Archivo generado: {archivo_salida}")
        abrir_archivo(archivo_salida)
    except Exception as e:
        actualizar_label(f"Error: {e}")

def iniciar_proceso(carpeta, archivo_salida, formato, mostrar_metadatos, actualizar_label, update_progress):
    """
    Inicia el proceso en un hilo separado para mantener la UI responsiva.
    """
    hilo = threading.Thread(
        target=procesar,
        args=(carpeta, archivo_salida, formato, mostrar_metadatos, actualizar_label, update_progress)
    )
    hilo.start()

def exportar_zip(carpeta, actualizar_label):
    """
    Exporta la carpeta seleccionada a un archivo ZIP.
    """
    if not carpeta:
        actualizar_label("No hay carpeta seleccionada para exportar.")
        return
    zip_dest = filedialog.asksaveasfilename(defaultextension=".zip", filetypes=[("Zip files", "*.zip")])
    if zip_dest:
        base_name = os.path.splitext(zip_dest)[0]  # Quitar la extensión, si la tiene
        try:
            shutil.make_archive(base_name, 'zip', carpeta)
            actualizar_label(f"Archivo ZIP generado: {zip_dest}")
            abrir_archivo(zip_dest)
        except Exception as e:
            actualizar_label(f"Error al generar ZIP: {e}")

# -------------------------------
# Interfaz Gráfica
# -------------------------------

def main():
    root = Tk()
    root.title("Generador de Estructura")
    root.geometry("750x550")
    
    # Estilo y tema inicial
    style = Style(theme='cosmo')  # Tema claro inicial
    current_theme = {"mode": "light"}  # Usamos un diccionario mutable para almacenar el tema actual
    
    # Variables de la interfaz
    ruta_carpeta = StringVar()
    ruta_archivo = StringVar()
    mostrar_metadatos_var = BooleanVar(value=False)
    formato_var = StringVar(value="Markdown")  # Opciones: Markdown, TXT, JSON, HTML

    # Funciones de selección de carpeta y archivo
    def seleccionar_carpeta():
        carpeta = filedialog.askdirectory()
        if carpeta:
            ruta_carpeta.set(carpeta)

    def seleccionar_archivo():
        archivo = filedialog.asksaveasfilename(
            defaultextension=".md",
            filetypes=[
                ("Markdown files", "*.md"),
                ("TXT files", "*.txt"),
                ("JSON files", "*.json"),
                ("HTML files", "*.html")
            ]
        )
        if archivo:
            ruta_archivo.set(archivo)
    
    def actualizar_label(texto):
        estado_var.set(texto)
        root.update_idletasks()
    
    # Función para actualizar la barra de progreso (thread-safe)
    def update_progress(current, total):
        percent = (current / total) * 100 if total > 0 else 0
        root.after(0, lambda: progress_bar.configure(value=percent))
    
    # Función para alternar el tema (modo oscuro/claro)
    def toggle_theme():
        if current_theme["mode"] == "light":
            current_theme["mode"] = "dark"
            style.theme_use("darkly")
            actualizar_label("Tema cambiado a oscuro.")
        else:
            current_theme["mode"] = "light"
            style.theme_use("cosmo")
            actualizar_label("Tema cambiado a claro.")
    
    # Botón para exportar la carpeta a ZIP
    def boton_exportar_zip():
        exportar_zip(ruta_carpeta.get(), actualizar_label)
    
    # Diseño de la interfaz
    frame = ttk.Frame(root, padding=20)
    frame.pack(fill='both', expand=True)
    
    # Selección de carpeta de origen
    ttk.Label(frame, text="Carpeta de Origen:").grid(row=0, column=0, sticky=W, pady=5)
    ttk.Entry(frame, textvariable=ruta_carpeta, width=50).grid(row=0, column=1, pady=5, padx=5)
    ttk.Button(frame, text="Seleccionar Carpeta", command=seleccionar_carpeta).grid(row=0, column=2, pady=5)
    
    # Selección de archivo de salida
    ttk.Label(frame, text="Archivo de Salida:").grid(row=1, column=0, sticky=W, pady=5)
    ttk.Entry(frame, textvariable=ruta_archivo, width=50).grid(row=1, column=1, pady=5, padx=5)
    ttk.Button(frame, text="Seleccionar Archivo", command=seleccionar_archivo).grid(row=1, column=2, pady=5)
    
    # Opción para mostrar metadatos
    ttk.Checkbutton(
        frame, text="Mostrar metadatos (tamaño y fecha)", variable=mostrar_metadatos_var
    ).grid(row=2, column=0, columnspan=3, pady=5)
    
    # Selección de formato (Markdown, TXT, JSON, HTML)
    ttk.Label(frame, text="Formato de Salida:").grid(row=3, column=0, sticky=W, pady=5)
    formato_combobox = ttk.Combobox(
        frame, textvariable=formato_var,
        values=["Markdown", "TXT", "JSON", "HTML"],
        state="readonly", width=47
    )
    formato_combobox.grid(row=3, column=1, pady=5, padx=5, columnspan=2, sticky=W)
    
    # Botón para iniciar el proceso de generación
    ttk.Button(
        frame, text="Iniciar Proceso",
        command=lambda: iniciar_proceso(
            ruta_carpeta.get(),
            ruta_archivo.get(),
            formato_var.get(),
            mostrar_metadatos_var.get(),
            actualizar_label,
            update_progress
        )
    ).grid(row=4, column=1, pady=20)
    
    # Botón para cambiar el tema (modo oscuro/claro)
    ttk.Button(frame, text="Cambiar Tema", command=toggle_theme).grid(row=5, column=0, pady=5)
    
    # Botón para exportar la carpeta a ZIP
    ttk.Button(frame, text="Exportar a ZIP", command=boton_exportar_zip).grid(row=5, column=2, pady=5)
    
    # Etiqueta de estado
    estado_var = StringVar()
    estado_var.set("Esperando para iniciar...")
    ttk.Label(frame, textvariable=estado_var, bootstyle="info").grid(row=6, column=0, columnspan=3, pady=10)
    
    # Barra de progreso
    progress_bar = ttk.Progressbar(frame, orient='horizontal', mode='determinate', maximum=100)
    progress_bar.grid(row=7, column=0, columnspan=3, pady=10, sticky='ew')
    
    frame.columnconfigure(1, weight=1)
    root.mainloop()

if __name__ == "__main__":
    main()
