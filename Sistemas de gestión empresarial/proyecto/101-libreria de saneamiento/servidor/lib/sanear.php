<?php

	function sanear($elemento){
		//var_dump($elemento);
		$coleccion = ['delete', 'drop', 'truncate'];
		$entradas = $elemento;
		foreach ($entradas as $clave=>$valor) {
			 
			$entrada = $clave;
			if (array_filter($coleccion, fn($elemento) => strpos($entrada, $elemento) !== false)) {
				 die('{"resultado":"error 2"}');
			} 
			$entrada = $valor;
			if (array_filter($coleccion, fn($elemento) => strpos($entrada, $elemento) !== false)) {
				die('{"resultado":"error 2"}');
			} 
			 
		}
	}

?>
