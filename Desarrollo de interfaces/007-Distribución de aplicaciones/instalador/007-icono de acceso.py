import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import zipfile
import os
import threading
import subprocess
import sys
import platform
from pathlib import Path

# Intentar importar winshell y pywin32 para la creación de accesos directos en Windows
try:
    import winshell
    from win32com.client import Dispatch
    ACCESO_DIRECTO_WINDOWS_DISPONIBLE = True
except ImportError:
    ACCESO_DIRECTO_WINDOWS_DISPONIBLE = False

class Instalador(tk.Tk):
    def __init__(self):
        super().__init__()

        self.title("Asistente de Instalación")
        self.geometry("500x450")
        self.resizable(False, False)

        self.ruta_instalacion = tk.StringVar(value=os.getcwd())

        self.marcos = {}

        for F in (PantallaBienvenida, PantallaSeleccionarCarpeta, PantallaProgreso, PantallaExito):
            marco = F(self)
            self.marcos[F] = marco
            marco.grid(row=0, column=0, sticky="nsew")

        self.mostrar_marco(PantallaBienvenida)

    def mostrar_marco(self, clase_marco):
        marco = self.marcos[clase_marco]
        marco.tkraise()
        if hasattr(marco, 'al_mostrar'):
            marco.al_mostrar()

class PantallaBienvenida(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)

        etiqueta_titulo = tk.Label(self, text="Bienvenido al Instalador de Mi Proyecto", font=("Arial", 16, "bold"))
        etiqueta_titulo.pack(pady=20)

        etiqueta_descripcion = tk.Label(self,
            text="Este instalador le guiará a través de los pasos\n"
                 "para instalar la aplicación en su sistema.")
        etiqueta_descripcion.pack(pady=10)

        boton_siguiente = ttk.Button(self, text="Siguiente", command=self.ir_siguiente)
        boton_siguiente.pack(pady=20)

        self.parent = parent

    def ir_siguiente(self):
        self.parent.mostrar_marco(PantallaSeleccionarCarpeta)

class PantallaSeleccionarCarpeta(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)

        etiqueta_instruccion = tk.Label(self, text="Seleccionar Carpeta de Instalación", font=("Arial", 12, "bold"))
        etiqueta_instruccion.pack(pady=20)

        marco_carpeta = tk.Frame(self)
        marco_carpeta.pack(pady=5)

        self.entrada_carpeta = tk.Entry(marco_carpeta, textvariable=parent.ruta_instalacion, width=40)
        self.entrada_carpeta.pack(side="left", padx=(0, 10))

        boton_examinar = ttk.Button(marco_carpeta, text="Examinar...", command=self.examinar_carpeta)
        boton_examinar.pack(side="left")

        self.etiqueta_error = tk.Label(self, text="", fg="red", font=("Arial", 10))
        self.etiqueta_error.pack(pady=5)

        self.boton_siguiente = ttk.Button(self, text="Siguiente", command=self.ir_siguiente)
        self.boton_siguiente.pack(pady=20)
        self.boton_siguiente.config(state="disabled")

        self.parent = parent
        self.parent.ruta_instalacion.trace_add('write', self.al_cambiar_ruta)
        self.verificar_carpeta_vacia()

    def examinar_carpeta(self):
        carpeta = filedialog.askdirectory(initialdir=os.getcwd(), title="Seleccionar Carpeta de Instalación")
        if carpeta:
            self.parent.ruta_instalacion.set(carpeta)

    def al_cambiar_ruta(self, *args):
        self.verificar_carpeta_vacia()

    def verificar_carpeta_vacia(self):
        ruta = self.parent.ruta_instalacion.get()
        if os.path.isdir(ruta):
            try:
                if not os.listdir(ruta):
                    self.boton_siguiente.config(state="normal")
                    self.etiqueta_error.config(text="")
                else:
                    self.boton_siguiente.config(state="disabled")
                    self.etiqueta_error.config(text="La carpeta seleccionada no está vacía. Por favor, elija una carpeta vacía.")
            except PermissionError:
                self.boton_siguiente.config(state="disabled")
                self.etiqueta_error.config(text="Permiso denegado para acceder a la carpeta seleccionada.")
            except Exception as e:
                self.boton_siguiente.config(state="disabled")
                self.etiqueta_error.config(text=f"Error al acceder a la carpeta: {str(e)}")
        else:
            self.boton_siguiente.config(state="disabled")
            self.etiqueta_error.config(text="La ruta seleccionada no es un directorio válido.")

    def ir_siguiente(self):
        self.parent.mostrar_marco(PantallaProgreso)

class PantallaProgreso(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)

        etiqueta_titulo = tk.Label(self, text="Instalando...", font=("Arial", 14, "bold"))
        etiqueta_titulo.pack(pady=20)

        self.progreso = ttk.Progressbar(self, orient="horizontal", length=300, mode="determinate")
        self.progreso.pack(pady=10)

        self.etiqueta_estado = tk.Label(self, text="Preparando para instalar...", font=("Arial", 10))
        self.etiqueta_estado.pack(pady=5)

        self.boton_siguiente = ttk.Button(self, text="Siguiente", command=self.ir_siguiente)
        self.boton_siguiente.pack(pady=20)
        self.boton_siguiente.config(state="disabled")

        self.parent = parent
        self.instalacion_iniciada = False

    def al_mostrar(self):
        if not self.instalacion_iniciada:
            self.instalacion_iniciada = True
            threading.Thread(target=self.iniciar_extraccion, daemon=True).start()

    def iniciar_extraccion(self):
        archivo_original = "paquete.zip"
        salida = self.parent.ruta_instalacion.get()
        directorio_script = os.path.dirname(os.path.abspath(__file__))
        ruta_zip = os.path.join(directorio_script, archivo_original)

        if not os.path.isfile(ruta_zip):
            messagebox.showerror("Error", f"No se puede encontrar '{archivo_original}' en '{directorio_script}'.")
            self.etiqueta_estado.config(text="La instalación falló.")
            return

        try:
            with zipfile.ZipFile(ruta_zip, 'r') as zipped:
                lista_archivos = zipped.namelist()
                total_archivos = len(lista_archivos)

                for i, archivo in enumerate(lista_archivos, start=1):
                    zipped.extract(archivo, salida)
                    valor_progreso = int((i / total_archivos) * 100)
                    self.progreso["value"] = valor_progreso
                    self.etiqueta_estado.config(text=f"Extrayendo {archivo} ({i}/{total_archivos})")
                    self.parent.update_idletasks()

            self.etiqueta_estado.config(text="Extracción completada.")
            self.boton_siguiente.config(state="normal")

        except Exception as e:
            messagebox.showerror("Error", f"Ocurrió un error durante la extracción:\n{str(e)}")
            self.etiqueta_estado.config(text="La instalación falló.")

    def ir_siguiente(self):
        self.parent.mostrar_marco(PantallaExito)

class PantallaExito(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)

        etiqueta_exito = tk.Label(self, text="¡Instalación Exitosa!", font=("Arial", 14, "bold"))
        etiqueta_exito.pack(pady=20)

        etiqueta_detalle = tk.Label(self, text="Su aplicación se ha instalado correctamente.", font=("Arial", 10))
        etiqueta_detalle.pack(pady=10)

        self.lanzar_var = tk.BooleanVar(value=True)
        self.casilla_lanzar = tk.Checkbutton(self, text="Lanzar Aplicación Ahora", variable=self.lanzar_var, font=("Arial", 10))
        self.casilla_lanzar.pack(pady=10)

        self.acceso_directo_var = tk.BooleanVar(value=True)
        self.casilla_acceso_directo = tk.Checkbutton(self, text="Crear Acceso Directo en el Escritorio", variable=self.acceso_directo_var, font=("Arial", 10))
        self.casilla_acceso_directo.pack(pady=5)

        boton_salir = ttk.Button(self, text="Finalizar", command=self.finalizar_instalacion)
        boton_salir.pack(pady=20)

        self.parent = parent

    def finalizar_instalacion(self):
        if self.acceso_directo_var.get():
            self.parent.after(0, self.crear_acceso_directo)

        if self.lanzar_var.get():
            self.lanzar_main_py()

        self.parent.destroy()

    def crear_acceso_directo(self):
        sistema_actual = platform.system()
        ruta_destino = os.path.join(self.parent.ruta_instalacion.get(), "main.py")
        nombre_acceso_directo = "Mi Aplicación"

        if not os.path.isfile(ruta_destino):
            messagebox.showerror("Error", f"No se puede encontrar 'main.py' en '{self.parent.ruta_instalacion.get()}'. No se puede crear el acceso directo.")
            return

        if sistema_actual == "Windows":
            self.crear_acceso_directo_windows(ruta_destino, nombre_acceso_directo)
        elif sistema_actual == "Darwin":
            self.crear_acceso_directo_macos(ruta_destino, nombre_acceso_directo)
        elif sistema_actual == "Linux":
            self.crear_acceso_directo_linux(ruta_destino, nombre_acceso_directo)
        else:
            messagebox.showerror("Error", f"Sistema operativo no soportado: {sistema_actual}. No se puede crear el acceso directo.")

    def crear_acceso_directo_windows(self, ruta_destino, nombre_acceso_directo):
        if not ACCESO_DIRECTO_WINDOWS_DISPONIBLE:
            messagebox.showerror("Error", "Los módulos winshell y pywin32 no están instalados. No se puede crear el acceso directo en Windows.")
            return

        try:
            escritorio = Path.home() / "Desktop"
            ruta_acceso_directo = os.path.join(escritorio, f"{nombre_acceso_directo}.lnk")
            with winshell.shortcut(ruta_acceso_directo) as enlace:
                enlace.path = sys.executable
                enlace.arguments = f'"{ruta_destino}"'
                enlace.description = "Lanzar Mi Aplicación"
                enlace.icon_location = (sys.executable, 0)
            messagebox.showinfo("Éxito", "Acceso directo en el escritorio creado exitosamente.")
        except Exception as e:
            messagebox.showerror("Error", f"Fallo al crear el acceso directo en Windows:\n{str(e)}")

    def crear_acceso_directo_macos(self, ruta_destino, nombre_acceso_directo):
        try:
            escritorio = os.path.join(os.path.join(os.path.expanduser('~')), 'Desktop')
            ruta_alias = os.path.join(escritorio, f"{nombre_acceso_directo}.app")
            applescript = f'''
            tell application "Finder"
                make alias file to POSIX file "{ruta_destino}" at POSIX file "{escritorio}"
                set name of result to "{nombre_acceso_directo}.app"
            end tell
            '''
            subprocess.run(['osascript', '-e', applescript], check=True)
            messagebox.showinfo("Éxito", "Alias en el escritorio creado exitosamente.")
        except subprocess.CalledProcessError as e:
            messagebox.showerror("Error", f"Fallo al crear el alias en macOS:\n{str(e)}")
        except Exception as e:
            messagebox.showerror("Error", f"Ocurrió un error inesperado:\n{str(e)}")

    def crear_acceso_directo_linux(self, ruta_destino, nombre_acceso_directo):
        try:
            escritorio = os.path.join(os.path.expanduser('~'), 'Desktop')
            ruta_acceso_directo = os.path.join(escritorio, f"{nombre_acceso_directo}.desktop")
            entrada_escritorio = f"""[Desktop Entry]
Type=Application
Name={nombre_acceso_directo}
Exec={sys.executable} "{ruta_destino}"
Icon=utilities-terminal
Terminal=false
"""
            with open(ruta_acceso_directo, 'w') as f:
                f.write(entrada_escritorio)
            os.chmod(ruta_acceso_directo, 0o755)
            messagebox.showinfo("Éxito", "Acceso directo en el escritorio creado exitosamente.")
        except Exception as e:
            messagebox.showerror("Error", f"Fallo al crear el acceso directo en Linux:\n{str(e)}")

    def lanzar_main_py(self):
        ruta_main_py = os.path.join(self.parent.ruta_instalacion.get(), "main.py")
        if not os.path.isfile(ruta_main_py):
            messagebox.showerror("Error", f"No se puede encontrar 'main.py' en '{self.parent.ruta_instalacion.get()}'.")
            return
        try:
            subprocess.Popen([sys.executable, ruta_main_py], cwd=self.parent.ruta_instalacion.get())
        except Exception as e:
            messagebox.showerror("Error", f"Fallo al lanzar 'main.py':\n{str(e)}")

if __name__ == "__main__":
    app = Instalador()
    app.mainloop()
