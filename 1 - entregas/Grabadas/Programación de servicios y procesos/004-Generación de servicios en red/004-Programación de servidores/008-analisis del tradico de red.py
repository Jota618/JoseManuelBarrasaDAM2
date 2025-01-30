import speedtest
import time

def measure_speeds():
    st = speedtest.Speedtest()

    print("Finding best server...")
    st.get_best_server()

    # Measure download speed
    print("Measuring download speed...")
    download_start = time.time()
    download_speed = st.download()
    download_duration = time.time() - download_start
    download_speed_mbps = (download_speed / 8) / 1_000_000

    # Measure upload speed
    print("Measuring upload speed...")
    upload_start = time.time()
    upload_speed = st.upload()
    upload_duration = time.time() - upload_start
    upload_speed_mbps = (upload_speed / 8) / 1_000_000

    print(f"Download Stream (Speed): {download_speed_mbps / download_duration:.2f} MB/s")
    print(f"Upload Stream (Speed): {upload_speed_mbps / upload_duration:.2f} MB/s")

if __name__ == "__main__":
    measure_speeds()
