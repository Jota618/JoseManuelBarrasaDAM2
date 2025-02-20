import subprocess

def shutdown_machine():
    try:
        # Shutdown the machine with a delay of 1 minute (adjust 'now' for immediate shutdown)
        subprocess.run(["sudo", "shutdown", "now"], check=True)
        print("Shutting down the machine...")
    except subprocess.CalledProcessError as e:
        print(f"Failed to shut down the machine: {e}")

if __name__ == "__main__":
    shutdown_machine()
