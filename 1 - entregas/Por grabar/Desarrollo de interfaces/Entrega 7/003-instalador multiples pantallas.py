import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import zipfile
import os
import threading

class Installer(tk.Tk):
    def __init__(self):
        super().__init__()
        
        self.title("Installer Wizard")
        self.geometry("500x300")
        self.resizable(False, False)
        
        # Store the folder selected by the user
        self.install_path = tk.StringVar(value=os.getcwd())  # default to current working directory
        
        # Prepare frames (screens)
        self.frames = {}
        
        for F in (WelcomeScreen, SelectFolderScreen, ProgressScreen, SuccessScreen):
            frame = F(self)
            self.frames[F] = frame
            frame.grid(row=0, column=0, sticky="nsew")
        
        # Show the Welcome screen first
        self.show_frame(WelcomeScreen)

    def show_frame(self, frame_class):
        """
        Bring the specified frame to the front.
        If the frame has an 'on_show' method, call it.
        """
        frame = self.frames[frame_class]
        frame.tkraise()
        if hasattr(frame, 'on_show'):
            frame.on_show()

class WelcomeScreen(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)
        
        # Title label
        title_label = tk.Label(self, text="Welcome to My Project Installer", font=("Arial", 16, "bold"))
        title_label.pack(pady=20)
        
        # Description
        description_label = tk.Label(self, 
            text="This installer will guide you through the steps\n"
                 "to install the application on your system.")
        description_label.pack(pady=10)
        
        # Next button
        next_button = ttk.Button(self, text="Next", command=self.go_next)
        next_button.pack(pady=20)
        
        self.parent = parent

    def go_next(self):
        self.parent.show_frame(SelectFolderScreen)

class SelectFolderScreen(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)
        
        # Instruction label
        instruction_label = tk.Label(self, text="Select installation folder", font=("Arial", 12, "bold"))
        instruction_label.pack(pady=20)
        
        # Folder input
        self.folder_entry = tk.Entry(self, textvariable=parent.install_path, width=40)
        self.folder_entry.pack(pady=5)
        
        # Browse button
        browse_button = ttk.Button(self, text="Browse...", command=self.browse_folder)
        browse_button.pack(pady=5)
        
        # Next button
        next_button = ttk.Button(self, text="Next", command=self.go_next)
        next_button.pack(pady=20)
        
        self.parent = parent
    
    def browse_folder(self):
        folder = filedialog.askdirectory(initialdir=os.getcwd(), title="Select installation folder")
        if folder:
            self.parent.install_path.set(folder)
    
    def go_next(self):
        # Optionally validate folder path here
        if not self.parent.install_path.get():
            messagebox.showerror("Error", "Please select a valid folder.")
            return
        
        self.parent.show_frame(ProgressScreen)

class ProgressScreen(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)
        
        # Title
        title_label = tk.Label(self, text="Installing...", font=("Arial", 14, "bold"))
        title_label.pack(pady=20)
        
        # Progress bar
        self.progress = ttk.Progressbar(self, orient="horizontal", length=300, mode="determinate")
        self.progress.pack(pady=10)
        
        # Status label
        self.status_label = tk.Label(self, text="Preparing to install...")
        self.status_label.pack(pady=5)
        
        # Next button (initially disabled)
        self.next_button = ttk.Button(self, text="Next", command=self.go_next)
        self.next_button.pack(pady=20)
        self.next_button.config(state="disabled")
        
        self.parent = parent
        self.installation_started = False  # Flag to prevent multiple starts

    def on_show(self):
        """
        Called when the ProgressScreen is shown.
        Starts the extraction if not already started.
        """
        if not self.installation_started:
            self.installation_started = True
            threading.Thread(target=self.start_extraction, daemon=True).start()

    def start_extraction(self):
        archivo_original = "paquete.zip"
        salida = self.parent.install_path.get()
        
        # Optional: Determine the path of the zip file relative to the script
        script_dir = os.path.dirname(os.path.abspath(__file__))
        zip_path = os.path.join(script_dir, archivo_original)
        
        if not os.path.isfile(zip_path):
            messagebox.showerror("Error", f"Cannot find '{archivo_original}' in '{script_dir}'.")
            self.status_label.config(text="Installation failed.")
            return

        try:
            with zipfile.ZipFile(zip_path, 'r') as zipped:
                # Get file list to compute progress
                file_list = zipped.namelist()
                total_files = len(file_list)
                
                for i, file in enumerate(file_list, start=1):
                    zipped.extract(file, salida)
                    
                    # Update progress
                    progress_value = int((i / total_files) * 100)
                    self.progress["value"] = progress_value
                    
                    # Update UI elements
                    self.status_label.config(text=f"Extracting {file} ({i}/{total_files})")
                    self.parent.update_idletasks()
            
            # Extraction successful
            self.status_label.config(text="Extraction completed.")
            self.next_button.config(state="normal")
        except Exception as e:
            messagebox.showerror("Error", f"An error occurred:\n{str(e)}")
            self.status_label.config(text="Installation failed.")

    def go_next(self):
        self.parent.show_frame(SuccessScreen)

class SuccessScreen(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)
        
        # Title
        success_label = tk.Label(self, text="Installation Successful!", font=("Arial", 14, "bold"))
        success_label.pack(pady=30)
        
        # Description
        detail_label = tk.Label(self, text="Your application has been installed successfully.")
        detail_label.pack(pady=10)
        
        # Exit button
        exit_button = ttk.Button(self, text="Exit", command=self.exit_installer)
        exit_button.pack(pady=20)
        
        self.parent = parent
    
    def exit_installer(self):
        self.parent.destroy()

if __name__ == "__main__":
    app = Installer()
    app.mainloop()
