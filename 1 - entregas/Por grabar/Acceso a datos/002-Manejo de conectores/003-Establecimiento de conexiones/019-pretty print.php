<?php

// Establece una conexión a la base de datos MySQL utilizando las credenciales proporcionadas
$mysqli = mysqli_connect("localhost", "accesoadatos", "accesoadatos", "accesoadatos"); // Conecta al servidor MySQL con el usuario y contraseña especificados y selecciona la base de datos

// Define la consulta SQL para seleccionar todos los registros de la tabla 'empleados'
$query = "SELECT * FROM empleados"; // Consulta que obtiene todos los registros de la tabla empleados

// Ejecuta la consulta en la base de datos y almacena el resultado
$result = mysqli_query($mysqli, $query); // Ejecuta la consulta y guarda el resultado en la variable $result

// Inicializa un array vacío para almacenar los resultados
$resultado = []; // Crea un array que almacenará todas las filas obtenidas de la consulta

// Itera sobre cada fila del resultado de la consulta
while ($row = mysqli_fetch_assoc($result)) { // Mientras haya filas en el resultado
    $resultado[] = $row; // Agrega cada fila al array $resultado
}

// Convierte el array de resultados a formato JSON con un formato legible
$json = json_encode($resultado, JSON_PRETTY_PRINT); // Codifica el array $resultado en formato JSON con sangrías para mejor legibilidad

// Envía el JSON como respuesta al navegador
echo $json; // Muestra el JSON generado, que puede ser consumido por el cliente
?>