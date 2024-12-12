import psutil

# Get the CPU load as a percentage (for each core)
cpu_load_per_core = psutil.cpu_percent(interval=1, percpu=True)

# Get the total CPU load as a percentage
total_cpu_load = psutil.cpu_percent(interval=1)

print(f"CPU load per core: {cpu_load_per_core}")
print(f"Total CPU load: {total_cpu_load}%")
