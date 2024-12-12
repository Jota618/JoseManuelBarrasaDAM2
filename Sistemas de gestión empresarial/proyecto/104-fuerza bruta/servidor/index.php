<?php
	include "lib/sanear.php";
	sanear($_REQUEST);
	$json = file_get_contents('php://input');                   								// Recojo los datos que vienen en json desde la petición del cliente
   $datos = json_decode($json, true);
	sanear($datos);
	
	include "lib/fuerzabruta.php";
	
	ini_set('display_errors', 1);																								// Activo errores
	ini_set('display_startup_errors', 1);																				// Activo errores de inicio
	error_reporting(E_ALL);																											// 

	include "ConexionDB.php";	
	include "ConectaMongo.php";																									// incluyo el archivo en el cual se encuentra la clase

	$conexion = new conexionDB();
	$conexionmongo = new ConectaMongo();
																								// Creo una nueva instancia de la clase
	if(isset($_GET['o'])){
		switch($_GET['o']){
			case "listatablas":
				echo $conexion->listadoTablas();																						// Llamo a un metodo
				break;
			case "estadisticastablas":
				echo $conexion->contarFilasTablas();																						// Llamo a un metodo
				break;
			case "listacolecciones":
				echo $conexionmongo->listarColecciones();																						// Llamo a un metodo
				break;
			case "listadocumentos":
				echo $conexionmongo->listar($_GET['coleccion']);																						// Llamo a un metodo
				break;
			case "tabla":
				echo $conexion->seleccionaTabla($_GET['tabla']);																						// Llamo a un metodo
				break;
			case "columnastabla":
				echo $conexion->columnasTabla($_GET['tabla']);																						// Llamo a un metodo
				break;
			case "eliminar":
				echo $conexion->eliminaTabla($_GET['tabla'],$_GET['id']);																						// Llamo a un metodo
				break;
			case "buscar":
				$json = file_get_contents('php://input');                   								// Recojo los datos que vienen en json desde la petición del cliente
        		$datos = json_decode($json, true);																					// Me aseguro que ese json tenga una forma que PHP pueda entender
				echo $conexion->buscar($_GET['tabla'],$datos);																						// Llamo a un metodo
				break;
			case "actualizar":
				$json = file_get_contents('php://input');                   								// Recojo los datos que vienen en json desde la petición del cliente
        		$datos = json_decode($json, true);																					// Me aseguro que ese json tenga una forma que PHP pueda entender
				echo $conexion->actualizar($datos);																						// Llamo a un metodo
				break;
			case "buscarSimilar":
				$json = file_get_contents('php://input');                   								// Recojo los datos que vienen en json desde la petición del cliente
        		$datos = json_decode($json, true);																					// Me aseguro que ese json tenga una forma que PHP pueda entender
				echo $conexion->buscarSimilar($_GET['tabla'],$datos);																						// Llamo a un metodo
				break;
			case "insertar":
				$json = file_get_contents('php://input');                   								// Recojo los datos que vienen en json desde la petición del cliente
        $datos = json_decode($json, true);																					// Me aseguro que ese json tenga una forma que PHP pueda entender
				echo $conexion->insertaTabla($_GET['tabla'],$datos);																						// Llamo a un metodo
				break;
		}
	}
	
	include "lib/registros.php";
	
?>
