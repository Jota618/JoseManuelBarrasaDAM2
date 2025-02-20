import subprocess

def block_port():
    # Get user input
    port = input("Enter the port you want to block: ").strip()
    ip = input("Enter the IP address to block (leave blank for all IPs): ").strip()
    
    # Validate input
    if not port.isdigit():
        print("Invalid port number. Please enter a valid numeric port.")
        return

    # Build the iptables command
    if ip:
        command = f"sudo iptables -A INPUT -p tcp --dport {port} -s {ip} -j DROP"
    else:
        command = f"sudo iptables -A INPUT -p tcp --dport {port} -j DROP"

    try:
        # Execute the iptables command
        subprocess.run(command, shell=True, check=True)
        print(f"Successfully blocked port {port}{' for IP ' + ip if ip else ''}.")
    except subprocess.CalledProcessError as e:
        print(f"Error: {e}. Make sure you have sudo privileges.")

if __name__ == "__main__":
    block_port()
