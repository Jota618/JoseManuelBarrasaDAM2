
	let tamanio = 1;
	let cantidadcontraste = 1
	let contenedor = document.createElement("div")
	contenedor.classList.add("jvampliador")
	let invertido = false;
	
	////////////////// AUMENTAR /////////////////
	
	let aumentar = document.createElement("button")
	aumentar.textContent = "+"
	
	contenedor.appendChild(aumentar)
	aumentar.onclick = function(){
		tamanio *= 1.1;
		document.querySelector("body").style.fontSize = tamanio+"em"
	}
	
	////////////////// CONTRASTE /////////////////
	
	let contraste = document.createElement("button")
	contraste.textContent = "C"
	
	contenedor.appendChild(contraste)
	contraste.onclick = function(){
		cantidadcontraste = 30;
		document.querySelector("body").style.filter = "contrast("+cantidadcontraste+")"
	}
	
	////////////////// INVERTIR /////////////////
	
	let invertir = document.createElement("button")
	invertir.textContent = "I"
	
	contenedor.appendChild(invertir)
	invertir.onclick = function(){
		if(invertido == false){
			document.querySelector("body").style.filter = "invert(1) hue-rotate(180deg)"
			invertido = true
		}else{
			document.querySelector("body").style.filter = "invert(0) hue-rotate(0deg)"
			invertido = false
		}
	}
	
	////////////////// DISMINUIR /////////////////
	
	let disminuir = document.createElement("button")
	disminuir.textContent = "-"
	contenedor.appendChild(disminuir)
	
	disminuir.onclick = function(){
		tamanio *= 0.9;
		document.querySelector("body").style.fontSize = tamanio+"em"
	}
	
	document.querySelector("body").appendChild(contenedor)

