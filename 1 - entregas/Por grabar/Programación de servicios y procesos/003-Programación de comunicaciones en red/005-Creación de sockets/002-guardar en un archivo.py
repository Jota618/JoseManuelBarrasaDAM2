import psutil

cpu_load_per_core = psutil.cpu_percent(interval=1, percpu=True)

total_cpu_load = psutil.cpu_percent(interval=1)

archivo = open("rendimiento.txt",'a')
archivo.write(str(total_cpu_load)+"\n")
archivo.close()
