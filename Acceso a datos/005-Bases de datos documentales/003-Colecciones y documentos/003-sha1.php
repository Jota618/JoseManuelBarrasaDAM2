<?php
	
	$contrasena = "Jose Vicente";
	$picadillo0 = md5($contrasena);
	$picadillo = sha1($contrasena);
	$picadillo2 = sha1($contrasena);
	
	echo $picadillo0;
	echo "<br>";
	echo $picadillo;
	echo "<br>";
	echo $picadillo2;
?>
