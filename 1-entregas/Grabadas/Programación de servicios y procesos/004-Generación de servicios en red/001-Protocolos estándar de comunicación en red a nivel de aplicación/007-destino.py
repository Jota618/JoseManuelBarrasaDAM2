import requests

# Define the endpoint URL
url = "http://localhost/dam/Segundo/Programaci%C3%B3n%20de%20servicios%20y%20procesos/004-Generaci%C3%B3n%20de%20servicios%20en%20red/001-Protocolos%20est%C3%A1ndar%20de%20comunicacio%CC%81n%20en%20red%20a%20nivel%20de%20aplicacio%CC%81n/006-sacar%20pedidos/api.php?o=clientes"  # Replace with your actual endpoint

try:
    # Make a GET request to fetch the data
    response = requests.get(url)
    response.raise_for_status()  # Raise an error for HTTP errors (4xx, 5xx)

    # Parse the JSON response into Python objects
    data = response.json()

    # Structure the data into a dictionary
    structured_data = {}
    for entry in data:
        cliente = entry["cliente"]
        nombre_completo = f"{cliente['nombre']} {cliente['apellidos']}"
        pedidos = entry.get("pedidos", [])
        pedido_list = [
            {
                "fecha": pedido["fecha"],
                "lineas_pedido": [
                    {"producto": lp["producto"], "cantidad": lp["cantidad"]}
                    for lp in pedido.get("lineaspedido", [])
                ],
            }
            for pedido in pedidos
        ]
        structured_data[nombre_completo] = pedido_list

    # Print the structured dictionary
    print(structured_data)

except requests.RequestException as e:
    print(f"An error occurred while making the request: {e}")
except ValueError as e:
    print(f"An error occurred while parsing the JSON: {e}")
