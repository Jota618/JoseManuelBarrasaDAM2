<?php
define('DB_HOST', 'localhost');
define('DB_USER', 'empresa');
define('DB_PASS', 'empresa');
define('DB_NAME', 'portfolio');

// Crear conexión
$conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}
?>
