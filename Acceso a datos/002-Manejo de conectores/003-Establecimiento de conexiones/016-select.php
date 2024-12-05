<?php

$mysqli = mysqli_connect("localhost", "accesoadatos", "accesoadatos", "accesoadatos");
$query = "SELECT * FROM empleados";
$result = mysqli_query($mysqli, $query);
while ($row = mysqli_fetch_assoc($result)) {
    var_dump($row);
}

?>
