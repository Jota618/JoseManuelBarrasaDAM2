<?php
// Conexión a la base de datos SQLite
$db = new SQLite3('targets.db');

// Obtener el término de búsqueda y sanitizarlo
$search = isset($_GET['search']) ? trim($_GET['search']) : '';
$search = SQLite3::escapeString($search);

// Consulta SQL con filtro de búsqueda
$query = "SELECT target FROM target_attributes WHERE target LIKE '%$search%' LIMIT 10";
$result = $db->query($query);

// HTML para el buscador
echo '<!DOCTYPE html>';
echo '<html lang="es">';
echo '<head>';
echo '<meta charset="UTF-8">';
echo '<meta name="viewport" content="width=device-width, initial-scale=1.0">';
echo '<title>Arañas | Buscador</title>';
echo '<style>';
echo 'body { font-family: Arial, sans-serif; background-color: #f4f4f4; text-align: center; padding: 20px; }';
echo 'h2 { color: #333; }';
echo 'form { margin-bottom: 20px; }';
echo 'input[type="text"] { padding: 10px; width: 300px; border: 1px solid #ccc; border-radius: 5px; }';
echo 'button { padding: 10px 20px; background-color: #007BFF; color: white; border: none; border-radius: 5px; cursor: pointer; }';
echo 'button:hover { background-color: #0056b3; }';
echo 'ul { list-style: none; padding: 0; }';
echo 'li { background: white; margin: 5px auto; padding: 10px; width: 50%; border-radius: 5px; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1); }';
echo 'a { text-decoration: none; color: #007BFF; }';
echo 'a:hover { text-decoration: underline; }';
echo '</style>';
echo '</head>';
echo '<body>';
echo '<h2>Buscador</h2>';
echo '<form method="GET">';
echo '<input type="text" name="search" placeholder="Buscar..." value="'.htmlspecialchars($search).'">';
echo '<button type="submit">Buscar</button>';
echo '</form>';

echo '<ul>';
while ($row = $result->fetchArray(SQLITE3_ASSOC)) {
    echo '<li><a href="'.htmlspecialchars($row['target']).'" target="_blank">'.htmlspecialchars($row['target']).'</a></li>';
}
echo '</ul>';
echo '</body>';
echo '</html>';

// Cerrar la conexión a la base de datos
$db->close();
