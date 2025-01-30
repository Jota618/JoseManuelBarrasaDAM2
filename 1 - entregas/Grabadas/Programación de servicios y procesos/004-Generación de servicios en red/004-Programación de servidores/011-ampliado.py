import psutil
import time

interval = 1

print("Empezamos el cálculo de valores normales")

# Function to calculate network usage over a given interval
def get_network_usage(interval):
    initial_net_io = psutil.net_io_counters()
    time.sleep(interval)
    net_io = psutil.net_io_counters()
    subida = (net_io.bytes_sent - initial_net_io.bytes_sent) / interval
    descarga = (net_io.bytes_recv - initial_net_io.bytes_recv) / interval
    return subida, descarga

# Calculate average values over 10 seconds
total_subida = 0
total_descarga = 0

for _ in range(10):
    s, d = get_network_usage(interval)
    total_subida += s
    total_descarga += d

subida = total_subida / 10
descarga = total_descarga / 10
print(f"Valores normales: Subida={subida:.2f} bytes/s, Descarga={descarga:.2f} bytes/s")

print("Ahora comenzamos la toma de datos")

# Monitor real-time network usage
previous_net_io = psutil.net_io_counters()

while True:
    current_net_io = psutil.net_io_counters()
    # Get network usage for the last second
    nuevasubida = (current_net_io.bytes_sent - previous_net_io.bytes_sent) / interval
    nuevadescarga = (current_net_io.bytes_recv - previous_net_io.bytes_recv) / interval
    
    # Update the previous I/O counters
    previous_net_io = current_net_io
    
    # Check for anomalies
    if nuevasubida > subida * 5 or nuevadescarga > descarga * 5:
        print(f"Anomalía detectada: Subida={nuevasubida:.2f} bytes/s, Descarga={nuevadescarga:.2f} bytes/s")
    else:
        print(f"Normal: Subida={nuevasubida:.2f} bytes/s, Descarga={nuevadescarga:.2f} bytes/s")
    
    time.sleep(interval)
