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

        # Establecer un estilo personalizado con ttk
        self.style = ttk.Style(self)
        self.style.configure("TButton",
                             font=("Helvetica", 10, "bold"),
                             padding=6,
                             relief="flat", 
                             background="#4CAF50", 
                             foreground="black")
        self.style.map("TButton",
                       background=[("active", "#45a049")])
        self.style.configure("TLabel",
                             font=("Helvetica", 11),
                             background="#f1f1f1",
                             foreground="#333")
        self.style.configure("TEntry",
                             font=("Helvetica", 10),
                             padding=5)

        self.ruta_instalacion = tk.StringVar(value=os.getcwd())
        self.opcion_instalacion = tk.StringVar(value="completa")

        # Diccionario para almacenar las pantallas
        self.marcos = {}

        for F in (PantallaLicencia, PantallaBienvenida, PantallaSeleccionarCarpeta, PantallaTipoInstalacion, PantallaProgreso, PantallaExito):
            marco = F(self)
            self.marcos[F] = marco
            marco.grid(row=0, column=0, sticky="nsew")

        self.mostrar_marco(PantallaLicencia)  # Mostramos primero la pantalla de licencia

    def mostrar_marco(self, clase_marco):
        marco = self.marcos[clase_marco]
        marco.tkraise()
        if hasattr(marco, 'al_mostrar'):
            marco.al_mostrar()

class PantallaLicencia(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)

        etiqueta_titulo = tk.Label(self, text="Acuerdo de Licencia", font=("Helvetica", 16, "bold"))
        etiqueta_titulo.pack(pady=20)

        etiqueta_licencia = tk.Label(self,
            text="Por favor, lea el siguiente acuerdo de licencia:\n\n"
                 "Este software es proporcionado tal cual, sin garantías de ningún tipo.\n"
                 "Al continuar, acepta los términos establecidos en este acuerdo.\n\n"
                 "Si no está de acuerdo, puede salir de la instalación en cualquier momento.",
            justify="left", font=("Helvetica", 10))
        etiqueta_licencia.pack(pady=10, padx=20)

        self.aceptar_var = tk.BooleanVar(value=False)
        casilla_aceptar = tk.Checkbutton(self, text="Acepto los términos de la licencia", variable=self.aceptar_var, font=("Helvetica", 10))
        casilla_aceptar.pack(pady=10)

        self.boton_siguiente = ttk.Button(self, text="Siguiente", command=self.ir_siguiente, state="disabled")
        self.boton_siguiente.pack(pady=20)

        self.boton_salir = ttk.Button(self, text="Cancelar", command=self.salir_instalador)
        self.boton_salir.pack(pady=5)

        self.parent = parent
        self.aceptar_var.trace_add('write', self.activar_boton_siguiente)

    def activar_boton_siguiente(self, *args):
        if self.aceptar_var.get():
            self.boton_siguiente.config(state="normal")
        else:
            self.boton_siguiente.config(state="disabled")

    def ir_siguiente(self):
        if self.aceptar_var.get():
            self.parent.mostrar_marco(PantallaBienvenida)

    def salir_instalador(self):
        self.parent.destroy()

class PantallaBienvenida(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)

        etiqueta_titulo = tk.Label(self, text="Bienvenido al Instalador de Mi Proyecto", font=("Helvetica", 16, "bold"))
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

        etiqueta_instruccion = tk.Label(self, text="Seleccionar Carpeta de Instalación", font=("Helvetica", 12, "bold"))
        etiqueta_instruccion.pack(pady=20)

        marco_carpeta = tk.Frame(self)
        marco_carpeta.pack(pady=5)

        self.entrada_carpeta = tk.Entry(marco_carpeta, textvariable=parent.ruta_instalacion, width=40)
        self.entrada_carpeta.pack(side="left", padx=(0, 10))

        boton_examinar = ttk.Button(marco_carpeta, text="Examinar...", command=self.examinar_carpeta)
        boton_examinar.pack(side="left")

        self.etiqueta_error = tk.Label(self, text="", fg="red", font=("Helvetica", 10))
        self.etiqueta_error.pack(pady=5)

        self.boton_atras = ttk.Button(self, text="Atrás", command=self.ir_atras)
        self.boton_atras.pack(side="left", padx=(5, 10), pady=20)

        self.boton_siguiente = ttk.Button(self, text="Siguiente", command=self.ir_siguiente)
        self.boton_siguiente.pack(side="right", pady=20)
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

    def ir_atras(self):
        self.parent.mostrar_marco(PantallaBienvenida)

    def ir_siguiente(self):
        self.parent.mostrar_marco(PantallaTipoInstalacion)

class PantallaTipoInstalacion(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)

        etiqueta_titulo = tk.Label(self, text="Seleccione Tipo de Instalación", font=("Arial", 14, "bold"))
        etiqueta_titulo.pack(pady=20)

        etiqueta_instruccion = tk.Label(self, text="Elija si desea una instalación completa o personalizada.", font=("Arial", 10))
        etiqueta_instruccion.pack(pady=10)

        self.radiobutton_completa = ttk.Radiobutton(self, text="Instalación Completa", variable=parent.opcion_instalacion, value="completa", command=self.actualizar_opcion)
        self.radiobutton_completa.pack(pady=5)

        self.radiobutton_personalizada = ttk.Radiobutton(self, text="Instalación Personalizada", variable=parent.opcion_instalacion, value="personalizada", command=self.actualizar_opcion)
        self.radiobutton_personalizada.pack(pady=5)

        self.boton_atras = ttk.Button(self, text="Atrás", command=self.ir_atras)
        self.boton_atras.pack(side="left", padx=(5, 10), pady=20)

        self.boton_siguiente = ttk.Button(self, text="Siguiente", command=self.ir_siguiente)
        self.boton_siguiente.pack(side="right", pady=20)
        self.boton_siguiente.config(state="normal")

        self.parent = parent

    def actualizar_opcion(self):
        if self.parent.opcion_instalacion.get() == "personalizada":
            print("Opción personalizada seleccionada.")
        else:
            print("Opción completa seleccionada.")

    def ir_atras(self):
        self.parent.mostrar_marco(PantallaSeleccionarCarpeta)

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

        self.boton_atras = ttk.Button(self, text="Atrás", command=self.ir_atras)
        self.boton_atras.pack(side="left", padx=(5, 10), pady=20)

        self.boton_siguiente = ttk.Button(self, text="Siguiente", command=self.ir_siguiente)
        self.boton_siguiente.pack(side="right", pady=20)
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

        self.progreso["value"] = 0
        self.progreso["maximum"] = 100
        self.etiqueta_estado.config(text="Extrayendo archivos...")

        try:
            with zipfile.ZipFile(ruta_zip, "r") as zip_ref:
                total_archivos = len(zip_ref.infolist())
                for i, archivo in enumerate(zip_ref.infolist()):
                    zip_ref.extract(archivo, salida)
                    progreso = (i + 1) * 100 / total_archivos
                    self.progreso["value"] = progreso
                    self.update_idletasks()
            self.progreso["value"] = 100
            self.etiqueta_estado.config(text="Instalación completada correctamente.")
            self.boton_siguiente.config(state="normal")
        except Exception as e:
            self.etiqueta_estado.config(text="Error al extraer archivos.")
            print(f"Error: {e}")

    def ir_atras(self):
        self.parent.mostrar_marco(PantallaTipoInstalacion)

    def ir_siguiente(self):
        self.parent.mostrar_marco(PantallaExito)

class PantallaExito(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)

        etiqueta_titulo = tk.Label(self, text="¡Instalación Completa!", font=("Arial", 14, "bold"))
        etiqueta_titulo.pack(pady=20)

        etiqueta_descripcion = tk.Label(self, text="La instalación se completó correctamente.")
        etiqueta_descripcion.pack(pady=10)

        boton_terminar = ttk.Button(self, text="Terminar", command=self.terminar_instalacion)
        boton_terminar.pack(pady=20)

        self.parent = parent

    def terminar_instalacion(self):
        self.parent.destroy()


    def finalizar_instalacion(self):
        if self.acceso_directo_var.get():
            self.parent.after(0, self.crear_acceso_directo)

        if self.lanzar_var.get():
            self.lanzar_main_py()

        self.parent.destroy()

    def crear_acceso_directo(self):
        # Aquí iría la lógica para crear accesos directos (lo has hecho bien en tu código original)
        pass

    def lanzar_main_py(self):
        # Aquí iría la lógica para lanzar el archivo principal
        pass

if __name__ == "__main__":
    app = Instalador()
    app.mainloop()
