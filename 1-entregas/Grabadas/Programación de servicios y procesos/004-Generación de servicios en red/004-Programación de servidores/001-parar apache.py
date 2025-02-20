import subprocess

def stop_apache():
    try:
        # Use systemctl to stop Apache
        subprocess.run(["sudo", "systemctl", "stop", "apache2"], check=True)
        print("Apache server stopped successfully.")
    except subprocess.CalledProcessError:
        print("Failed to stop Apache server.")

if __name__ == "__main__":
    stop_apache()
