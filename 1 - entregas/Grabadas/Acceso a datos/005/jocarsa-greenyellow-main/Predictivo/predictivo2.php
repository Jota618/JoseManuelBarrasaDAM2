<?php
// Abrir la base de datos SQLite
$db = new SQLite3('database.db');

$entrada = isset($_GET['entrada']) ? $_GET['entrada'] : '';

// Usar consulta preparada para evitar inyección SQL
$stmt = $db->prepare("SELECT siguiente FROM palabras WHERE previas = :previas");
$stmt->bindValue(':previas', $entrada, SQLITE3_TEXT);
$result = $stmt->execute();

$arreglo = [];
while ($row = $result->fetchArray(SQLITE3_ASSOC)) {
    $arreglo[] = $row['siguiente'];
}

echo json_encode($arreglo);
$db->close();
?>
