<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Jocarsa | Greenyellow</title>
  <style>
  body{
  	text-align:center;
  }
  input{
  	border:1px solid grey;
  	border-radius:50px;
  	padding:10px;
  }
    	.neurona{width:16px;height:16px;border:5px solid white;float:left;transition:all 1s;border-radius:100%;margin:4px;box-shadow:0px 3px 6px rgba(0,0,0,0.3);opacity:0.5;}
    	#neuronas{
    		width:170px;height:170px;margin:auto;margin-top:0px;margin-bottom:0px;
    	}
    	.activo{background:black;}
        #output {
            margin-top: 20px;
            font-family: monospace;
            white-space: pre-wrap;
            word-wrap: break-word;
            width:200px;
            margin:auto;
            transition:all 1s;
            background:black;
            padding:10px;
            border-radius:40px;
        }
        #output span{
        	width:8px;
        	height:8px;
        	display:inline-block;
        	text-align:center;
        	line-height:10px;
        	transition:all 1s;
        	font-weight:bold;
        	color:white;
        }
  </style>
</head>
<body>
	<input>
	<div id="neuronas">
		<?php
			for($i = 97;$i<122;$i++){
				echo '<div class="neurona" id="neurona'.$i.'"></div>';
			}
		?>
	</div>
    <div id="output"></div> <!-- New div for output -->
	<script>
	var todaslaspalabras;
  // Create a global dictionary to track each neurona's opacity
  let neuronOpacities = {};

  // Populate it initially as 0 for each neurona
  // (Or do 0.5 if you want them all to start half-visible.)
  document.querySelectorAll(".neurona").forEach(neurona => {
    neuronOpacities[neurona.id] = 0; 
  });

  let entrada = document.querySelector("input");
  let outputDiv = document.querySelector("#output");
	
  function procesa() {
    let datos = entrada.value.toLowerCase();
    let neuronas = document.querySelectorAll(".neurona");

    // If input is empty, reset all neuron opacities to 0
    if (!datos) {
      for (let id in neuronOpacities) {
        neuronOpacities[id] = 0;
      }
    } else {
      // Otherwise, let's re-initialize them all to 0 each time
      // and then increment only for the letters we see.
      // This ensures the final result is purely based on current input content.
      for (let id in neuronOpacities) {
        neuronOpacities[id] = 0;
      }

      // For each character in the input, increment that neuron's opacity
      for (let i = 0; i < datos.length; i++) {
        let ascii = datos.charCodeAt(i);
        let key = "neurona" + ascii;  // e.g. "neurona97" for 'a'

        if (neuronOpacities.hasOwnProperty(key)) {
          // Add 0.02 each time the letter appears.
          // This can be changed to whatever logic you want:
          // maybe 1 / length, or 0.1 per letter typed, etc.
          neuronOpacities[key] = Math.min(neuronOpacities[key] + 0.2, 1);
        }
      }
    }
	
    // Now, update the DOM based on the new opacity data
    neuronas.forEach(neurona => {
      let op = neuronOpacities[neurona.id] || 0;
      // If you want a baseline of 0.5 for everything, do:
      // let op = 0.5 + neuronOpacities[neurona.id];

      // Toggle .activo class if opacity > 0
      if (op > 0) {
        neurona.classList.add("activo");
      } else {
        neurona.classList.remove("activo");
      }
      // Apply inline style
      neurona.style.opacity = op;
    });

    // Finally, build the neuron string for output
    let neuronString = "";
    neuronas.forEach(neurona => {
      let op = neuronOpacities[neurona.id] || 0;
      let digit = Math.round(op * 9); // scale 0..1 to 0..9
      neuronString += "<span style='opacity:"+(digit/10+0.1)+";font-size:"+(digit+5)+"px'>"+digit+"</span>";
    });

    outputDiv.innerHTML = neuronString;
  };
  
  fetch("consumir/quijote.txt")
  .then(function(response){
  	return response.text()
  })
  .then(function(datos){
  		let palabras = datos.split(" ")
  		console.log(palabras)
  		todaslaspalabras = palabras
  })
  let temporizador = setTimeout("bucle()",1000)
  let contador = 0;
  function bucle(){
  	let cadena = ""
  	for(let i = 0;i<5;i++){
  		cadena += todaslaspalabras[contador+i]+" "
  	}
  	entrada.value = cadena
  	procesa()
  contador++;
  	clearTimeout(temporizador)
  	temporizador = setTimeout("bucle()",100)
  }
</script>
</body>
</html>

