import psutil
import time

def get_network_usage(interval=1):
    print("Measuring network bandwidth usage... (Ctrl+C to stop)")

    # Get initial stats
    initial_net_io = psutil.net_io_counters()
    time.sleep(interval)  # Wait for the interval

    while True:
        net_io = psutil.net_io_counters()

        # Calculate upload and download in bytes per second
        upload_speed = (net_io.bytes_sent - initial_net_io.bytes_sent) / interval
        download_speed = (net_io.bytes_recv - initial_net_io.bytes_recv) / interval

        # Update for the next loop
        initial_net_io = net_io

        print(f"Upload: {upload_speed / 1024:.2f} KB/s | Download: {download_speed / 1024:.2f} KB/s")
        time.sleep(interval)

if __name__ == "__main__":
    try:
        get_network_usage()
    except KeyboardInterrupt:
        print("\nMonitoring stopped.")
