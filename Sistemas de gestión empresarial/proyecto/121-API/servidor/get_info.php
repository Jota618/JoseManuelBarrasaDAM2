<?php
header('Content-Type: application/json');

// Database credentials
$host = 'localhost';
$dbname = 'crimson';
$username = 'crimson';
$password = 'crimson';

// Connect to the database using PDO
try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['error' => 'Database connection failed: ' . $e->getMessage()]);
    exit;
}

// Verify if parameters are available
$tabla = isset($_GET['tabla']) ? $_GET['tabla'] : '';
$id = isset($_GET['id']) ? intval($_GET['id']) : 0;

error_log("Tabla: " . $tabla);
error_log("ID: " . $id);

if ($tabla && $id) {
    try {
        // Use the correct column name: Identificador
        $stmt = $pdo->prepare("SELECT * FROM `$tabla` WHERE `Identificador` = :id");
        $stmt->bindParam(':id', $id, PDO::PARAM_INT);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($result) {
            // Return data as JSON
            echo json_encode($result);
        } else {
            echo json_encode(['error' => 'No data found']);
        }
    } catch (PDOException $e) {
        echo json_encode(['error' => 'Query failed: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['error' => 'Invalid parameters']);
}

?>