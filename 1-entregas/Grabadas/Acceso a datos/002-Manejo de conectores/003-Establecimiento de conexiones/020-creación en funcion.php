<?php
// Define una función llamada 'selecciona' que toma un parámetro llamado 'tabla'
function selecciona($tabla)
{
    // Establece una conexión a la base de datos MySQL utilizando las credenciales proporcionadas
    $mysqli = mysqli_connect("localhost", "accesoadatos", "accesoadatos", "accesoadatos"); // Conecta al servidor MySQL con el usuario y contraseña especificados y selecciona la base de datos

    // Define la consulta SQL para seleccionar todos los registros de la tabla proporcionada
    $query = "SELECT * FROM " . $tabla . ";"; // Crea la consulta SQL usando el nombre de la tabla pasado como argumento

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

    // Devuelve el JSON generado
    return $json; // Retorna el JSON que contiene los registros de la tabla
}

// Llama a la función 'selecciona' con el argumento "clientes" y muestra el resultado
echo selecciona("clientes"); // Ejecuta la función y muestra el JSON de la tabla 'clientes'
?>