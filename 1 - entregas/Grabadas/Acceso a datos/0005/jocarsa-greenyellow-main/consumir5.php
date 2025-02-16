<?php

	$db = new SQLite3('database.db');
	
	$query = "CREATE TABLE IF NOT EXISTS palabras (
		 id INTEGER PRIMARY KEY AUTOINCREMENT,
		 previas TEXT NOT NULL,
		 siguiente TEXT NOT NULL
	)";
	$db->exec($query);

	$archivo = file_get_contents("consumir/quijote.txt");
	$reemplazado = str_replace("\n"," ",$archivo);
	$partido = explode(" ",$reemplazado);
	//$seleccionado = array_slice($partido, 0, 101); 
	
	for($i = 0;$i<count($partido);$i++){
		$partido[$i] = strtolower($partido[$i]);
	}
	
	for($i = 0;$i<count($partido);$i++){
		echo $partido[$i]."+".$partido[$i+1]." luego va: ".$partido[$i+2]."<br>";
		
		$stmt = $db->prepare("INSERT INTO palabras (previas,siguiente) VALUES (:previas,:siguiente)");
		$stmt->bindValue(':previas', $partido[$i]." ".$partido[$i+1], SQLITE3_TEXT);
		$stmt->bindValue(':siguiente', $partido[$i+2], SQLITE3_TEXT);
		$stmt->execute();
	}
	
	$db->close();

?>
