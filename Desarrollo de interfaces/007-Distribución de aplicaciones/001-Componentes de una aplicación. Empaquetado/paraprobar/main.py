import os
import tkinter as tk
from tkinter import ttk, filedialog, messagebox
from PIL import Image, ExifTags
from datetime import datetime

class PhotoRenamerApp(tk.Tk):
    def __init__(self):
        super().__init__()
        
        # Configuración de ventana
        self.title("Photo Renamer (Mejorado)")
        self.geometry("550x550")
        self.configure(bg="#2C2F33")

        # Configuración de estilos
        style = ttk.Style()
        style.theme_use("clam")  # un tema que se vea decente
        style.configure("TFrame", background="#2C2F33")
        style.configure("TLabel", background="#2C2F33", foreground="white", font=("Arial", 10))
        style.configure("TButton", font=("Arial", 10), padding=5)
        style.configure("Horizontal.TProgressbar", troughcolor="#23272A", background="#7289DA")

        # Var para carpeta
        self.folder_path = tk.StringVar()
        # Var para prefijo
        self.prefix_var = tk.StringVar()

        # Frame principal
        main_frame = ttk.Frame(self)
        main_frame.pack(pady=10)

        # Logo (opcional)
        try:
            self.logo_image = tk.PhotoImage(file="logo.png")
            self.logo_label = ttk.Label(main_frame, image=self.logo_image)
            self.logo_label.pack(pady=5)
        except Exception:
            pass

        # Botón para seleccionar carpeta
        ttk.Button(main_frame, text="Seleccionar carpeta", command=self.select_folder).pack(pady=5)

        # Entrada para prefijo
        prefix_label = ttk.Label(main_frame, text="Prefijo para el nuevo nombre (opcional):")
        prefix_label.pack()
        prefix_entry = ttk.Entry(main_frame, textvariable=self.prefix_var, width=30)
        prefix_entry.pack(pady=5)

        # Botón para mostrar vista previa
        ttk.Button(main_frame, text="Vista previa", command=self.preview_files).pack(pady=5)

        # Cuadro de texto para lista de archivos
        self.text_preview = tk.Text(main_frame, height=10, width=50, bg="#23272A", fg="white")
        self.text_preview.config(state=tk.DISABLED)
        self.text_preview.pack(pady=5)

        # Botón para renombrar
        ttk.Button(main_frame, text="Renombrar", command=self.start_renaming).pack(pady=5)

        # Barra de progreso y etiqueta
        self.progress_var = tk.DoubleVar()
        self.progress_label = ttk.Label(main_frame, text="Progreso: 0%")
        self.progress_label.pack(pady=(15, 0))
        self.progress_bar = ttk.Progressbar(main_frame, orient="horizontal", length=400,
                                            mode="determinate", variable=self.progress_var)
        self.progress_bar.pack(pady=5)

    def select_folder(self):
        """Abre un diálogo para seleccionar la carpeta de imágenes."""
        selected_folder = filedialog.askdirectory()
        if selected_folder:
            self.folder_path.set(selected_folder)
            messagebox.showinfo("Carpeta Seleccionada", f"Carpeta seleccionada:\n{selected_folder}")

    def preview_files(self):
        """Muestra una vista previa de los archivos que se van a renombrar."""
        folder = self.folder_path.get()
        if not folder:
            messagebox.showwarning("Sin carpeta", "Por favor, selecciona una carpeta primero.")
            return

        # Extensiones a considerar
        extensions = (".jpg", ".jpeg", ".png", ".raw", ".heic")
        files = [f for f in os.listdir(folder) if f.lower().endswith(extensions)]

        self.text_preview.config(state=tk.NORMAL)
        self.text_preview.delete(1.0, tk.END)
        if not files:
            self.text_preview.insert(tk.END, "No se encontraron archivos de imagen en la carpeta seleccionada.")
        else:
            self.text_preview.insert(tk.END, "Archivos encontrados:\n")
            for file in files:
                self.text_preview.insert(tk.END, f"- {file}\n")
        self.text_preview.config(state=tk.DISABLED)

    def start_renaming(self):
        """Inicia el proceso de renombrado."""
        folder = self.folder_path.get()
        if not folder:
            messagebox.showwarning("Sin carpeta", "Por favor, selecciona una carpeta primero.")
            return
        
        self.rename_photos(folder)

    def rename_photos(self, folder):
        """Renombra imágenes basándose en su fecha EXIF o, si no hay EXIF, en fecha de modificación."""
        # Extensiones a considerar
        extensions = (".jpg", ".jpeg", ".png", ".raw", ".heic")
        images = [f for f in os.listdir(folder) if f.lower().endswith(extensions)]

        total_images = len(images)
        if total_images == 0:
            messagebox.showinfo("Sin imágenes", "No se encontraron imágenes en la carpeta seleccionada.")
            return

        prefix = self.prefix_var.get().strip()

        for i, image_name in enumerate(images, start=1):
            old_path = os.path.join(folder, image_name)
            new_filename = self.get_new_filename(old_path, image_name, prefix)

            # Realiza el renombrado
            if new_filename != image_name:
                new_path = os.path.join(folder, new_filename)
                # Si ya existe un archivo con ese nombre, busca un sufijo que funcione
                new_path = self.avoid_collision(new_path)
                os.rename(old_path, new_path)

            # Actualiza progreso
            progress_percent = (i / total_images) * 100
            self.progress_var.set(progress_percent)
            self.progress_label.config(text=f"Progreso: {int(progress_percent)}%")
            self.update_idletasks()

        messagebox.showinfo("Completado", "Renombrado finalizado.")

    def get_new_filename(self, file_path, original_filename, prefix):
        """Extrae la fecha EXIF o usa la fecha de modificación como fallback, añade prefijo si se indica."""
        # Intenta leer EXIF
        try:
            img = Image.open(file_path)
            exif_data = img._getexif()
            if exif_data:
                exif_dict = {
                    ExifTags.TAGS.get(tag_id, tag_id): value
                    for tag_id, value in exif_data.items()
                }
                date_str = exif_dict.get('DateTimeOriginal', None)
                if date_str:
                    # Formato "YYYY:MM:DD HH:MM:SS"
                    date_time_obj = datetime.strptime(date_str, "%Y:%m:%d %H:%M:%S")
                    new_basename = date_time_obj.strftime("%Y%m%d_%H%M%S")
                else:
                    new_basename = self.get_fallback_date(file_path)
            else:
                new_basename = self.get_fallback_date(file_path)
        except Exception:
            new_basename = self.get_fallback_date(file_path)

        # Construye el nombre final
        _, ext = os.path.splitext(original_filename)
        ext = ext.lower()
        # Reemplaza espacios en new_basename
        new_basename = new_basename.replace(" ", "_")

        if prefix:
            final_name = f"{prefix}_{new_basename}{ext}"
        else:
            final_name = f"{new_basename}{ext}"
        return final_name

    def get_fallback_date(self, file_path):
        """Devuelve la fecha de modificación del archivo en formato YYYYMMDD_HHMMSS."""
        timestamp = os.path.getmtime(file_path)
        date_time_obj = datetime.fromtimestamp(timestamp)
        return date_time_obj.strftime("%Y%m%d_%H%M%S")

    def avoid_collision(self, target_path):
        """Si el target_path existe, añade un sufijo incremental."""
        if not os.path.exists(target_path):
            return target_path
        
        base, ext = os.path.splitext(target_path)
        counter = 1
        new_path = f"{base}_{counter}{ext}"
        while os.path.exists(new_path):
            counter += 1
            new_path = f"{base}_{counter}{ext}"
        return new_path

if __name__ == "__main__":
    app = PhotoRenamerApp()
    app.mainloop()
