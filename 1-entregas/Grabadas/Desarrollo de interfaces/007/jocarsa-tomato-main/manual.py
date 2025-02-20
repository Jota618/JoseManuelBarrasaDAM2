import subprocess
import time

def main():
    script_path = "tomato.py"  # Replace with the actual path to your script
    try:
        while True:
            subprocess.run(["python3", script_path], check=True)  # Adjust 'python' if necessary (e.g., 'python3')
            time.sleep(1)  # Optional delay between iterations
    except KeyboardInterrupt:
        print("Loop stopped by user.")
    except subprocess.CalledProcessError as e:
        print(f"Script execution failed: {e}")

if __name__ == "__main__":
    main()
