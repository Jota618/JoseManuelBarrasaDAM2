<?php

	$archivo = file_get_contents("consumir/quijote.txt");
	$reemplazado = str_replace("\n"," ",$archivo);
	$partido = explode(" ",$reemplazado);
	//$seleccionado = array_slice($partido, 0, 101); 
	
	for($i = 0;$i<count($partido);$i++){
		$partido[$i] = strtolower($partido[$i]);
	}
	$frase = "este libro no tiene";
	
	$palabras = explode(" ",$frase);
	
	$indices = array_keys($partido, $palabras[0]);
	var_dump($indices);

?>
