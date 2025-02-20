import tkinter as tk

ventana = tk.Tk()

def diHola():
    print("Hola")

tk.Button(ventana,text="Pulsame",padx=15,pady=15,command=diHola).pack(padx=40,pady=40)

ventana.mainloop()
