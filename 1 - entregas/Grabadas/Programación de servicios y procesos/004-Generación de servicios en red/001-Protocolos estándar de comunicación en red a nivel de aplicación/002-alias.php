<?php


	$mysqli = mysqli_connect("localhost", "crimson", "crimson", "crimson");

	$peticion = "
		SELECT 
		clientes.nombre AS 'Nombre del cliente',
		clientes.apellidos AS 'Apellidos del cliente'
	 	FROM 
	 	clientes";

	$resultado = mysqli_query($mysqli, $peticion);
	
	$datos = [];
	
	while ($fila = mysqli_fetch_assoc($resultado)) {
		 $datos[] = $fila;
	}
	
	$json = json_encode($datos);
	echo $json;
	
?>

