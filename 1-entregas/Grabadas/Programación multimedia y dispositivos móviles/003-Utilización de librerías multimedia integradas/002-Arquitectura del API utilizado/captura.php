<?php
if ($_SERVER["REQUEST_METHOD"] === "POST" && isset($_FILES["screenshot"])) {
    $uploadDir = "uploads/";
    if (!is_dir($uploadDir)) {
        mkdir($uploadDir, 0777, true); // Crear carpeta si no existe
    }

    $fileName = $uploadDir . uniqid() . ".png";
    if (move_uploaded_file($_FILES["screenshot"]["tmp_name"], $fileName)) {
        echo $fileName; // Devolver la ruta de la imagen guardada
    } else {
        echo "Error al guardar la captura.";
    }
} else {
    echo "No se recibió ninguna captura.";
}
?>
