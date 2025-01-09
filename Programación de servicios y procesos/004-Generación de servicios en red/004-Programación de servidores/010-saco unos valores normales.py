import psutil
import time

interval=1


initial_net_io = psutil.net_io_counters()
time.sleep(interval)
descarga = 0
subida = 0

print("Empezamos el cálculo de valores normales")

for _ in range(0,10):
    net_io = psutil.net_io_counters()
    subida += (net_io.bytes_sent - initial_net_io.bytes_sent) / interval
    descarga += (net_io.bytes_recv - initial_net_io.bytes_recv) / interval
    initial_net_io = net_io   
    time.sleep(interval)

subida /= 10
descarga /= 10
print(subida,descarga)

print("Ahora comenzamos la toma de datos")

while True:
    net_io = psutil.net_io_counters()
    nuevasubida = (net_io.bytes_sent - initial_net_io.bytes_sent) / interval
    nuevadescarga = (net_io.bytes_recv - initial_net_io.bytes_recv) / interval
    if nuevasubida > subida*5 or nuevadescarga > descarga*5:
        print(nuevasubida,nuevadescarga)
        print("Hay alguna anomalía")
    else:
        print(nuevasubida,nuevadescarga)
        print("De momento todo parece normal")
    time.sleep(interval)
