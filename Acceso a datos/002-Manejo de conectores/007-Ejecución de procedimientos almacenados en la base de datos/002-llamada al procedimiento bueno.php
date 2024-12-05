<?php

	$mysqli = mysqli_connect("localhost", "crimson", "crimson", "crimson");

	$query = "CALL SeleccionaClientesBueno('car');";

	$result = mysqli_query($mysqli, $query);

	while ($row = mysqli_fetch_row($result)) {
		  var_dump($row);
	}

?>
