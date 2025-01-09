import os
import tkinter as tk
from tkinter import ttk
from tkinter import filedialog, messagebox
from PIL import Image, ExifTags
from datetime import datetime

class PhotoRenamerApp(tk.Tk):
    def __init__(self):
        super().__init__()
        
        self.title("Photo Renamer")
        self.geometry("400x350")
        
        # -- Logo --
        # Replace 'logo.png' with the path to your logo file.
        # If you don't have a logo, you can comment this out or remove it.
        try:
            self.logo_image = tk.PhotoImage(file="logo.png")
            self.logo_label = tk.Label(self, image=self.logo_image)
            self.logo_label.pack(pady=10)
        except Exception:
            # If the image file isn't found, we won't display the logo
            pass
        
        # -- Folder path variable --
        self.folder_path = tk.StringVar()
        
        # -- Select Folder Button --
        self.select_folder_button = ttk.Button(
            self, 
            text="Select Target Folder", 
            command=self.select_folder
        )
        self.select_folder_button.pack(pady=5)
        
        # -- Start Operation Button --
        self.start_button = ttk.Button(
            self, 
            text="Start Renaming", 
            command=self.start_renaming
        )
        self.start_button.pack(pady=5)
        
        # -- Progress Label --
        self.progress_label = tk.Label(self, text="Progress:")
        self.progress_label.pack(pady=(20, 0))
        
        # -- Progress Bar --
        self.progress_var = tk.DoubleVar()
        self.progress_bar = ttk.Progressbar(
            self, 
            orient="horizontal", 
            length=300, 
            mode="determinate", 
            variable=self.progress_var,
            maximum=100
        )
        self.progress_bar.pack()
        
    def select_folder(self):
        """Open a dialog to select the target folder."""
        selected_folder = filedialog.askdirectory()
        if selected_folder:
            self.folder_path.set(selected_folder)
            messagebox.showinfo("Folder Selected", f"Selected folder:\n{selected_folder}")
        
    def start_renaming(self):
        """Start the photo renaming process."""
        folder = self.folder_path.get()
        if not folder:
            messagebox.showwarning("No Folder Selected", "Please select a folder first.")
            return
        
        # Perform renaming in a separate function
        self.rename_photos(folder)
    
    def rename_photos(self, folder):
        """
        Renames all .jpg, .jpeg, .png images in the folder based on EXIF data.
        If EXIF does not contain 'DateTimeOriginal', the filename is unchanged.
        """
        # Gather list of images
        extensions = (".jpg", ".jpeg", ".png")
        all_files = os.listdir(folder)
        images = [f for f in all_files if f.lower().endswith(extensions)]
        
        total_images = len(images)
        if total_images == 0:
            messagebox.showinfo("No Images Found", "No JPG/PNG images found in the selected folder.")
            return
        
        for i, image_name in enumerate(images, start=1):
            old_path = os.path.join(folder, image_name)
            new_filename = self.get_new_filename(old_path, image_name)
            
            # Only rename if a new filename was generated (i.e., we found EXIF date)
            if new_filename and new_filename != image_name:
                new_path = os.path.join(folder, new_filename)
                
                # If the new path already exists, you might want to handle it (e.g., skip or add suffix).
                # Here, we simply check and skip if there's a clash.
                if not os.path.exists(new_path):
                    os.rename(old_path, new_path)
            
            # Update progress bar
            progress_percent = (i / total_images) * 100
            self.progress_var.set(progress_percent)
            self.update_idletasks()
        
        messagebox.showinfo("Done", "Renaming operation completed.")
        
    def get_new_filename(self, file_path, original_filename):
        """
        Tries to extract the EXIF 'DateTimeOriginal' from the image.
        If found, returns a new name formatted as YYYYMMDD_HHMMSS + extension.
        Otherwise, returns the original filename (meaning, no rename).
        """
        try:
            img = Image.open(file_path)
            exif_data = img._getexif()
            
            if exif_data is None:
                # No EXIF, return original name
                return original_filename
            
            # Convert raw EXIF tag IDs to human-readable tags
            exif_dict = {
                ExifTags.TAGS.get(tag_id, tag_id): value
                for tag_id, value in exif_data.items()
            }
            
            # Check for DateTimeOriginal
            date_str = exif_dict.get('DateTimeOriginal', None)
            if not date_str:
                # If there's no DateTimeOriginal, keep original filename
                return original_filename
            
            # Parse date string, typically in the format "YYYY:MM:DD HH:MM:SS"
            date_time_obj = datetime.strptime(date_str, "%Y:%m:%d %H:%M:%S")
            # Create a new filename with this format: YYYYMMDD_HHMMSS + ext
            new_basename = date_time_obj.strftime("%Y%m%d_%H%M%S")
            
            # Preserve original extension
            _, ext = os.path.splitext(original_filename)
            new_filename = new_basename + ext.lower()
            
            return new_filename
        
        except Exception:
            # If anything goes wrong (unsupported file, parse error, etc.), return original
            return original_filename


if __name__ == "__main__":
    app = PhotoRenamerApp()
    app.mainloop()
