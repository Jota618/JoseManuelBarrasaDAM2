<?php
  if (isset($_GET['datos']) && isset($_GET['turno'])) {
      $file = fopen("tablero.html", "w");
      fwrite($file, $_GET['datos'] . "<!--TURN-->" . $_GET['turno']);  // Store the board and turn
      fclose($file);
      echo "Board state and turn saved.";
  }
?>
