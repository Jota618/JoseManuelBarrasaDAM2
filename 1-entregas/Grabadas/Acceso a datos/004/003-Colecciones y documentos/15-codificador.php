<?php

// Función para codificar una cadena
function codifica($entrada) {
    // Modificar la cadena sumando 5 a cada carácter
    $modificada = '';
    for ($i = 0; $i < strlen($entrada); $i++) {
        $modificada .= chr(ord($entrada[$i]) + 5);
    }

    // Aplicar tres veces la codificación Base64
    $base64_1 = base64_encode($modificada);
    $base64_2 = base64_encode($base64_1);
    $base64_3 = base64_encode($base64_2);

    return $base64_3;
}

// Función para decodificar una cadena
function descodifica($entrada) {
    // Aplicar tres veces la decodificación Base64
    $base64_2 = base64_decode($entrada);
    if ($base64_2 === false) return null;

    $base64_1 = base64_decode($base64_2);
    if ($base64_1 === false) return null;

    $modificada = base64_decode($base64_1);
    if ($modificada === false) return null;

    // Restaurar la cadena restando 5 a cada carácter
    $resultado = '';
    for ($i = 0; $i < strlen($modificada); $i++) {
        $resultado .= chr(ord($modificada[$i]) - 5);
    }

    return $resultado;
}

// Prueba del sistema
$contrasena = "Jose Manuel";
echo "La contraseña original es: $contrasena\n";

$codificado = codifica($contrasena);
echo "La contraseña codificada es: $codificado\n";

$descodificado = descodifica($codificado);
echo "La contraseña decodificada es: $descodificado\n";

?>
