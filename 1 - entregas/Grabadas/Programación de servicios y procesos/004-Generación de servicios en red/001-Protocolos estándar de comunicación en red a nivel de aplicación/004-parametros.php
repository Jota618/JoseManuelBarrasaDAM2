<?php


	$mysqli = mysqli_connect("localhost", "crimson", "crimson", "crimson");
	switch($_GET['o']){
		case "clientes":
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
			$json = json_encode($datos, JSON_PRETTY_PRINT);
			echo $json;
			break;
		case "cliente":
			$peticion = "
				SELECT 
				clientes.nombre AS 'Nombre del cliente',
				clientes.apellidos AS 'Apellidos del cliente'
			 	FROM 
			 	clientes
			 	WHERE clientes.Identificador = ".$_GET['id']."
			 	";
			$resultado = mysqli_query($mysqli, $peticion);
			$datos = [];
			while ($fila = mysqli_fetch_assoc($resultado)) {
				 $datos[] = $fila;
			}
			$json = json_encode($datos, JSON_PRETTY_PRINT);
			echo $json;
			break;
		default:
			echo "{'resultado':'ko'}";
	}
	
	
?>

