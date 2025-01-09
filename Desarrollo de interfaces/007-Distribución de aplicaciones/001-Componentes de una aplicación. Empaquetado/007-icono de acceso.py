import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import zipfile
import os
import threading
import subprocess
import sys
import platform

# Attempt to import winshell and pywin32 for Windows shortcut creation
try:
    import winshell
    from win32com.client import Dispatch
    WINDOWS_SHORTCUT_AVAILABLE = True
except ImportError:
    WINDOWS_SHORTCUT_AVAILABLE = False

class Installer(tk.Tk):
    def __init__(self):
        super().__init__()
        
        self.title("Installer Wizard")
        self.geometry("500x450")  # Increased height to accommodate additional UI elements
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
        instruction_label = tk.Label(self, text="Select Installation Folder", font=("Arial", 12, "bold"))
        instruction_label.pack(pady=20)
        
        # Folder input frame
        folder_frame = tk.Frame(self)
        folder_frame.pack(pady=5)
        
        # Folder entry
        self.folder_entry = tk.Entry(folder_frame, textvariable=parent.install_path, width=40)
        self.folder_entry.pack(side="left", padx=(0, 10))
        
        # Browse button
        browse_button = ttk.Button(folder_frame, text="Browse...", command=self.browse_folder)
        browse_button.pack(side="left")
        
        # Error message label
        self.error_label = tk.Label(self, text="", fg="red", font=("Arial", 10))
        self.error_label.pack(pady=5)
        
        # Next button
        self.next_button = ttk.Button(self, text="Next", command=self.go_next)
        self.next_button.pack(pady=20)
        self.next_button.config(state="disabled")  # Initially disabled
        
        self.parent = parent
        
        # Add trace to install_path
        self.parent.install_path.trace_add('write', self.on_path_change)
        
        # Initial check
        self.check_folder_empty()

    def browse_folder(self):
        folder = filedialog.askdirectory(initialdir=os.getcwd(), title="Select Installation Folder")
        if folder:
            self.parent.install_path.set(folder)

    def on_path_change(self, *args):
        self.check_folder_empty()

    def check_folder_empty(self):
        path = self.parent.install_path.get()
        if os.path.isdir(path):
            try:
                if not os.listdir(path):  # Folder is empty
                    self.next_button.config(state="normal")
                    self.error_label.config(text="")
                else:
                    self.next_button.config(state="disabled")
                    self.error_label.config(text="Selected folder is not empty. Please choose an empty folder.")
            except PermissionError:
                self.next_button.config(state="disabled")
                self.error_label.config(text="Permission denied to access the selected folder.")
            except Exception as e:
                self.next_button.config(state="disabled")
                self.error_label.config(text=f"Error accessing folder: {str(e)}")
        else:
            self.next_button.config(state="disabled")
            self.error_label.config(text="Selected path is not a valid directory.")

    def go_next(self):
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
        self.status_label = tk.Label(self, text="Preparing to install...", font=("Arial", 10))
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
        
        # Determine the path of the zip file relative to the script
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
            messagebox.showerror("Error", f"An error occurred during extraction:\n{str(e)}")
            self.status_label.config(text="Installation failed.")

    def go_next(self):
        self.parent.show_frame(SuccessScreen)

class SuccessScreen(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)
        
        # Title
        success_label = tk.Label(self, text="Installation Successful!", font=("Arial", 14, "bold"))
        success_label.pack(pady=20)
        
        # Description
        detail_label = tk.Label(self, text="Your application has been installed successfully.", font=("Arial", 10))
        detail_label.pack(pady=10)
        
        # Checkbox variable
        self.launch_var = tk.BooleanVar(value=True)  # Default to checked
        
        # Checkbox
        self.launch_checkbox = tk.Checkbutton(
            self,
            text="Launch Application Now",
            variable=self.launch_var,
            font=("Arial", 10)
        )
        self.launch_checkbox.pack(pady=10)
        
        # Checkbox for creating desktop shortcut
        self.shortcut_var = tk.BooleanVar(value=True)  # Default to checked
        self.shortcut_checkbox = tk.Checkbutton(
            self,
            text="Create Desktop Shortcut",
            variable=self.shortcut_var,
            font=("Arial", 10)
        )
        self.shortcut_checkbox.pack(pady=5)
        
        # Exit button
        exit_button = ttk.Button(self, text="Finish", command=self.finish_installation)
        exit_button.pack(pady=20)
        
        self.parent = parent

    def finish_installation(self):
        # Create desktop shortcut if the checkbox is selected
        if self.shortcut_var.get():
            threading.Thread(target=self.create_shortcut, daemon=True).start()
        
        # Launch the application if the checkbox is selected
        if self.launch_var.get():
            self.launch_main_py()
        
        # Close the installer
        self.parent.destroy()

    def create_shortcut(self):
        current_os = platform.system()
        target_path = os.path.join(self.parent.install_path.get(), "main.py")
        shortcut_name = "My Application"  # You can customize the shortcut name
        
        if not os.path.isfile(target_path):
            messagebox.showerror("Error", f"Cannot find 'main.py' in '{self.parent.install_path.get()}'. Cannot create shortcut.")
            return
        
        if current_os == "Windows":
            self.create_windows_shortcut(target_path, shortcut_name)
        elif current_os == "Darwin":
            self.create_macos_shortcut(target_path, shortcut_name)
        elif current_os == "Linux":
            self.create_linux_shortcut(target_path, shortcut_name)
        else:
            messagebox.showerror("Error", f"Unsupported operating system: {current_os}. Cannot create shortcut.")

    def create_windows_shortcut(self, target_path, shortcut_name):
        if not WINDOWS_SHORTCUT_AVAILABLE:
            messagebox.showerror("Error", "winshell and pywin32 modules are not installed. Unable to create shortcut on Windows.")
            return
        
        try:
            desktop = winshell.desktop()
            shortcut_path = os.path.join(desktop, f"{shortcut_name}.lnk")
            with winshell.shortcut(shortcut_path) as link:
                link.path = sys.executable
                link.arguments = f'"{target_path}"'
                link.description = "Launch My Application"
                link.icon_location = (sys.executable, 0)
            messagebox.showinfo("Success", "Desktop shortcut created successfully.")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to create Windows shortcut:\n{str(e)}")

    def create_macos_shortcut(self, target_path, shortcut_name):
        try:
            # Path to the desktop
            desktop = os.path.join(os.path.join(os.path.expanduser('~')), 'Desktop')
            alias_path = os.path.join(desktop, f"{shortcut_name}.app")
            
            # AppleScript to create alias
            applescript = f'''
            tell application "Finder"
                make alias file to POSIX file "{target_path}" at POSIX file "{desktop}"
                set name of result to "{shortcut_name}.app"
            end tell
            '''
            subprocess.run(['osascript', '-e', applescript], check=True)
            messagebox.showinfo("Success", "Desktop alias created successfully.")
        except subprocess.CalledProcessError as e:
            messagebox.showerror("Error", f"Failed to create macOS alias:\n{str(e)}")
        except Exception as e:
            messagebox.showerror("Error", f"An unexpected error occurred:\n{str(e)}")

    def create_linux_shortcut(self, target_path, shortcut_name):
        try:
            desktop = os.path.join(os.path.expanduser('~'), 'Desktop')
            shortcut_path = os.path.join(desktop, f"{shortcut_name}.desktop")
            
            # Content of the .desktop file
            desktop_entry = f"""[Desktop Entry]
Type=Application
Name={shortcut_name}
Exec={sys.executable} "{target_path}"
Icon=utilities-terminal
Terminal=false
"""
            with open(shortcut_path, 'w') as f:
                f.write(desktop_entry)
            
            # Make the .desktop file executable
            os.chmod(shortcut_path, 0o755)
            messagebox.showinfo("Success", "Desktop shortcut created successfully.")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to create Linux shortcut:\n{str(e)}")

    def launch_main_py(self):
        """
        Launches the extracted main.py file.
        """
        main_py_path = os.path.join(self.parent.install_path.get(), "main.py")
        
        if not os.path.isfile(main_py_path):
            messagebox.showerror("Error", f"Cannot find 'main.py' in '{self.parent.install_path.get()}'.")
            return
        
        try:
            # Launch main.py using the same Python interpreter
            subprocess.Popen([sys.executable, main_py_path], cwd=self.parent.install_path.get())
        except Exception as e:
            messagebox.showerror("Error", f"Failed to launch 'main.py':\n{str(e)}")
            return

if __name__ == "__main__":
    app = Installer()
    app.mainloop()
