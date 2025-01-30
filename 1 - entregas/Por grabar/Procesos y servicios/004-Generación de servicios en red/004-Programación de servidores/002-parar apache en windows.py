import subprocess

def stop_apache():
    try:
        # Path to the Apache bin folder
        apache_bin_path = r"C:\Apache24\bin\httpd.exe"
        subprocess.run([apache_bin_path, "-k", "stop"], check=True)
        print("Apache server stopped successfully.")
    except subprocess.CalledProcessError:
        print("Failed to stop Apache server.")

if __name__ == "__main__":
    stop_apache()
