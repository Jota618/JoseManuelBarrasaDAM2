<?php
	ini_set('display_errors', 1);																								// Activo errores
	ini_set('display_startup_errors', 1);																				// Activo errores de inicio
	error_reporting(E_ALL);																											// 
	
	include "ConexionDB.php";																										// incluyo el archivo en el cual se encuentra la clase
	
	$conexion = new conexionDB();																								// Creo una nueva instancia de la clase
	if(isset($_GET['o'])){
		switch($_GET['o']){
			case "listatablas":
				echo $conexion->listadoTablas();																						// Llamo a un metodo
				break;
			case "tabla":
				echo $conexion->seleccionaTabla($_GET['tabla']);																						// Llamo a un metodo
				break;
			case "columnastabla":
				echo $conexion->columnasTabla($_GET['tabla']);																						// Llamo a un metodo
				break;
		}
	}
	
	
?>
