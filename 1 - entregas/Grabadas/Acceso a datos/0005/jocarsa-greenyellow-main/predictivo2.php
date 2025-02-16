<?php
	
	$db = new SQLite3('database.db');
	
	$frase = $_GET['entrada'];
	
	$query = "SELECT * FROM palabras WHERE previas = '".$_GET['entrada']."'";
	$result = $db->query($query);
	$arreglo = [];
	while ($row = $result->fetchArray(SQLITE3_ASSOC)) {
		 $arreglo[] = $row['siguiente'];
	}
	
	$end = microtime(true);

	echo json_encode($arreglo);
	
?>
