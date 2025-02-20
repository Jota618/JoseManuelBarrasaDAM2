window.onload = function(){
	let tamanio = 1;
	let contenedor = document.createElement("div")
	contenedor.classList.add("jvampliador")
	let aumentar = document.createElement("button")
	aumentar.textContent = "+"
	contenedor.appendChild(aumentar)
	aumentar.onclick = function(){
		tamanio *= 1.1;
		document.querySelector("body").style.fontSize = tamanio+"em"
	}
	
	let disminuir = document.createElement("button")
	disminuir.textContent = "-"
	contenedor.appendChild(disminuir)
	
	disminuir.onclick = function(){
		tamanio *= 0.9;
		document.querySelector("body").style.fontSize = tamanio+"em"
	}
	document.querySelector("body").appendChild(contenedor)
}
