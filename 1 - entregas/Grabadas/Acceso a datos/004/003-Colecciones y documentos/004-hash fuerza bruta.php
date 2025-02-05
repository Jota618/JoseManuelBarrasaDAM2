<?php

function getCombinations($letters) {
    $results = [];

    // Condición base
    if ($letters === "") {
        return [""];
    }
   
    $first = $letters[0];
    $rest = substr($letters, 1);
 
    $combinations = getCombinations($rest);
    
    foreach ($combinations as $combination) {
        $results[] = $combination;
        $results[] = $first . $combination;
    }
    
    return $results;
}

$letters = "abcdefghijk";

$combinations = getCombinations($letters);
foreach($combinations as $clave => $valor){
	echo $valor." : ".md5($valor)."<br>";
}

?>

