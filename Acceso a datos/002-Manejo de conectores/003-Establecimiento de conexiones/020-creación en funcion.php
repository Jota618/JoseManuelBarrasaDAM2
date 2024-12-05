<?php
	function selecciona($tabla){
		$mysqli = mysqli_connect(
			"localhost", 
			"accesoadatos", 
			"accesoadatos", 
			"accesoadatos"
			);
		$query = "SELECT * FROM ".$tabla.";";
		$result = mysqli_query($mysqli, $query);
		$resultado = [];
		while ($row = mysqli_fetch_assoc($result)) {
				$resultado[] = $row;
		}
		$json = json_encode($resultado, JSON_PRETTY_PRINT);
		return $json;
	}
	
	echo selecciona("clientes");
?>
