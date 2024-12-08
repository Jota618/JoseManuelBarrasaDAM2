
	let tamanio = 1;
	let cantidadcontraste = 1
	let contenedor = document.createElement("div")
	contenedor.classList.add("jvampliador")
	
	////////////////// AUMENTAR /////////////////
	
	let aumentar = document.createElement("button")
	aumentar.textContent = "+"
	
	contenedor.appendChild(aumentar)
	aumentar.onclick = function(){
		tamanio *= 1.1;
		document.querySelector("body").style.fontSize = tamanio+"em"
	}
	
	////////////////// AUMENTAR /////////////////
	
	let contraste = document.createElement("button")
	contraste.textContent = "C"
	
	contenedor.appendChild(contraste)
	contraste.onclick = function(){
		cantidadcontraste = 30;
		document.querySelector("body").style.filter = "contrast("+cantidadcontraste+")"
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

