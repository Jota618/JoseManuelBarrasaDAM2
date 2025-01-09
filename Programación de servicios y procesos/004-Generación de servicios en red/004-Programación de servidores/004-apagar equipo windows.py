import subprocess

def shutdown_machine():
    try:
        # Shutdown the machine immediately
        subprocess.run(["shutdown", "/s", "/t", "0"], check=True)
        print("Shutting down the machine...")
    except subprocess.CalledProcessError as e:
        print(f"Failed to shut down the machine: {e}")

if __name__ == "__main__":
    shutdown_machine()
