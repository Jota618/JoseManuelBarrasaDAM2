<style>
    body {
        font-family: Arial, sans-serif;
        margin: 20px;
        background-color: #f9f9f9;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 20px;
        background-color: #ffffff;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }
    th, td {
        padding: 12px;
        text-align: left;
        border: 1px solid #ddd;
    }
    th {
        background-color: crimson;
        color: white;
    }
    tr:nth-child(even) {
        background-color: #f2f2f2;
    }
    tr:hover {
        background-color: #eaf4ff;
    }
    .row-number {
        font-weight: bold;
        text-align: center;
    }
</style>
<?php
// Database connection details
$host = "localhost";
$username = "crimson";
$password = "crimson";
$database = "crimson";

// Create connection
$conn = new mysqli($host, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Define the SQL query
$sql = $_GET['sql'];

// Execute the query
$result = $conn->query($sql);

// Check if there are results
if ($result && $result->num_rows > 0) {
    echo "<table border='1'>";
    
    // Fetch and display column headers dynamically
    echo "<tr><th>#</th>"; // Add a column for row numbers
    $columns = $result->fetch_fields();
    foreach ($columns as $column) {
        echo "<th>" . htmlspecialchars($column->name) . "</th>";
    }
    echo "</tr>";
    
    // Display rows dynamically
    $rowNumber = 1;
    while ($row = $result->fetch_assoc()) {
        echo "<tr>";
        echo "<td>" . $rowNumber++ . "</td>"; // Add row number
        foreach ($row as $value) {
            echo "<td>" . htmlspecialchars($value) . "</td>";
        }
        echo "</tr>";
    }
    
    echo "</table>";
} else {
    echo "No results found.";
}

// Close the connection
$conn->close();
?>

