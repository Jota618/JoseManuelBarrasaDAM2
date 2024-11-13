import tkinter as tk
from tkinter import filedialog

ventana = tk.Tk()

marco = tk.Frame(ventana)
marco.pack(padx=10,pady=10)

def seleccionaEntrada():
    ruta = filedialog.askopenfilename()

selector_video_entrada = tk.Button(
    marco,
    text="Selecciona el video de entrada",
    command=seleccionaEntrada
    )

selector_video_entrada.pack(padx=50,pady=50);

ventana.mainloop()
