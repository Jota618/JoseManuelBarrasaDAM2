<?php

$contrasena = "Jose Vicente";



function codifica($entrada){
	for($i = 0;$i<strlen($entrada);$i++){
		$entrada[$i] = chr(ord($entrada[$i])+5);
	}
	return $entrada;
}

echo codifica($contrasena);

?>

