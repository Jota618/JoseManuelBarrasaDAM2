<?php
	$start = microtime(true);
	$archivo = file_get_contents("consumir/quijote.txt");
	$reemplazado = str_replace("\n"," ",$archivo);
	$partido = explode(" ",$reemplazado);
	//$seleccionado = array_slice($partido, 0, 101); 
	
	for($i = 0;$i<count($partido);$i++){
		$partido[$i] = strtolower($partido[$i]);
	}
	$frase = $_GET['entrada'];
	
	$palabras = explode(" ",$frase);
	
	$indices = array_keys($partido, $palabras[0]);
	$arreglo = [];
	for($i = 0;$i<count($indices);$i++){							// Primero busco "este"
		if($partido[$indices[$i] + 1] == $palabras[1]){						// Ahora busco "este libro"
			$arreglo[] = $partido[$indices[$i] + 2];
		}
	}
	$end = microtime(true);
	$executionTime = ($end - $start) * 1000;
	$arreglo[] = $executionTime;
	echo json_encode($arreglo);
?>
