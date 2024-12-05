<?php

	$mysqli = mysqli_connect("localhost", "accesoadatos", "accesoadatos", "accesoadatos");
	$query = "SELECT * FROM empleados";
	$result = mysqli_query($mysqli, $query);
	$resultado = [];
	while ($row = mysqli_fetch_assoc($result)) {
		  $resultado[] = $row;
	}
	$json = json_encode($resultado, JSON_PRETTY_PRINT);
	echo $json;

?>
