<?php
$host = "localhost";
$username = "crimson";
$password = "crimson";
$database = "crimson";

$conn = new mysqli($host, $username, $password, $database);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = $_GET['sql'];
$result = $conn->query($sql);

// Almacenar todos los datos y columnas
$rows = [];
$columns = [];
if ($result && $result->num_rows > 0) {
    $columns = $result->fetch_fields();
    $rows = $result->fetch_all(MYSQLI_ASSOC);
}

// Función para generar HTML usando los datos almacenados
function generateTableHTML($rows, $columns) {
    if (!empty($rows)) {
        $html = "<table border='1'>";
        $html .= "<tr><th>#</th>";
        foreach ($columns as $column) {
            $html .= "<th>" . htmlspecialchars($column->name) . "</th>";
        }
        $html .= "</tr>";

        $rowNumber = 1;
        foreach ($rows as $row) {
            $html .= "<tr><td>$rowNumber</td>";
            foreach ($row as $value) {
                $html .= "<td>" . htmlspecialchars($value) . "</td>";
            }
            $html .= "</tr>";
            $rowNumber++;
        }
        $html .= "</table>";
        return $html;
    } else {
        return "No results found.";
    }
}

// Función para generar CSV desde los datos almacenados
function generateCSV($rows, $columns) {
    if (!empty($rows)) {
        $output = fopen('php://output', 'w');
        
        // Encabezados
        $headers = ['#'];
        foreach ($columns as $col) {
            $headers[] = $col->name;
        }
        fputcsv($output, $headers);
        
        // Filas
        $rowNumber = 1;
        foreach ($rows as $row) {
            $csvRow = [$rowNumber];
            foreach ($row as $val) {
                $csvRow[] = $val;
            }
            fputcsv($output, $csvRow);
            $rowNumber++;
        }
        fclose($output);
    }
}

// Generar HTML
$tableHTML = generateTableHTML($rows, $columns);
echo $tableHTML;

// Exportar CSV
if (isset($_GET['export']) && $_GET['export'] == 'csv') {
    header('Content-Type: text/csv');
    header('Content-Disposition: attachment; filename="data.csv"');
    generateCSV($rows, $columns);
    exit;
}

// Botones de descarga
if (!empty($rows)) {
    $encodedTableHTML = base64_encode($tableHTML);
    echo '<div style="display: flex; gap: 10px; margin-top: 20px;">';
    
    // Botón HTML
    echo '<form method="post" action="download.php">';
    echo '<input type="hidden" name="table" value="'.$encodedTableHTML.'">';
    echo '<button type="submit">Descargar HTML</button>';
    echo '</form>';
    
    // Botón CSV
    echo '<form method="get" action="ejecuta.php">';
    echo '<input type="hidden" name="sql" value="'.htmlspecialchars($sql).'">';
    echo '<input type="hidden" name="export" value="csv">';
    echo '<button type="submit">Descargar CSV</button>';
    echo '</form>';
    
    echo '</div>';
}

$conn->close();
?>