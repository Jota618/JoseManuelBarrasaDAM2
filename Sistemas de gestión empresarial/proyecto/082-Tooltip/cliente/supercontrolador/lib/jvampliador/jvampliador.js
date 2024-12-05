let tamanio = 1;
let cantidadcontraste = 1;
let contenedor = document.createElement("div");
contenedor.classList.add("jvampliador");
let invertido = false;

////////////////// AUMENTAR /////////////////

let aumentar = document.createElement("button");
aumentar.textContent = "+";
aumentar.setAttribute("aria-label", "Ampliar");
aumentar.setAttribute("title", "Ampliar el tamaño de la letra");

contenedor.appendChild(aumentar);
aumentar.onclick = function () {
	tamanio *= 1.1;
	document.querySelector("body").style.fontSize = tamanio + "em";
};

////////////////// DISMINUIR /////////////////

let disminuir = document.createElement("button");
disminuir.textContent = "-";
disminuir.setAttribute("aria-label", "Disminuir el tamaño de la fuente");
contenedor.appendChild(disminuir);

disminuir.onclick = function () {
	tamanio *= 0.9;
	document.querySelector("body").style.fontSize = tamanio + "em";
};

document.querySelector("body").appendChild(contenedor);

////////////////// CONTRASTE /////////////////

let contraste = document.createElement("button");
contraste.textContent = "C";
contraste.setAttribute("aria-label", "Contraste");

contenedor.appendChild(contraste);
contraste.onclick = function () {
	cantidadcontraste = 30;
	document.querySelector("body").style.filter = "contrast(" + cantidadcontraste + ")";
};

////////////////// INVERTIR /////////////////

let invertir = document.createElement("button");
invertir.textContent = "I";
invertir.setAttribute("aria-label", "Invertir");

contenedor.appendChild(invertir);
invertir.onclick = function () {
	if (invertido == false) {
		document.querySelector("body").style.filter = "invert(1) hue-rotate(180deg)";
		invertido = true;
	} else {
		document.querySelector("body").style.filter = "invert(0) hue-rotate(0deg)";
		invertido = false;
	}
};

////////////////// FUENTE /////////////////

let fuentes = ["averta", "Sans-serif", "personalizada", "calibri"];
let fuente = document.createElement("button");
fuente.textContent = "F";
fuente.setAttribute("aria-label", "Cambiar la fuente");

contenedor.appendChild(fuente);

// Crear el menú desplegable para cambiar la fuente
let fuenteMenu = document.createElement("select");
fuenteMenu.setAttribute("aria-label", "Seleccionar fuente");
fuenteMenu.style.display = "none"; // Inicialmente oculto
fuenteMenu.classList.add("fuente-menu"); // Añadir clase para personalización de CSS

// Añadir opciones al desplegable
let opcionDefecto = document.createElement("option");
opcionDefecto.textContent = "Selecciona una fuente";
opcionDefecto.disabled = true;
opcionDefecto.selected = true;
fuenteMenu.appendChild(opcionDefecto);

fuentes.forEach((fuente, index) => {
	let opcion = document.createElement("option");
	opcion.textContent = fuente;
	opcion.value = fuente;
	fuenteMenu.appendChild(opcion);
});

contenedor.appendChild(fuenteMenu);

// Mostrar y ocultar el menú al hacer clic en el botón "F"
fuente.onclick = function () {
	if (fuenteMenu.style.display === "none") {
		fuenteMenu.style.display = "block"; // Mostrar el menú
	} else {
		fuenteMenu.style.display = "none"; // Ocultar el menú
	}
};

// Cambiar la fuente al seleccionar una opción
fuenteMenu.addEventListener("change", function () {
	let fuenteSeleccionada = fuenteMenu.value;
	document.querySelector("body").style.fontFamily = fuenteSeleccionada;
	fuenteMenu.style.display = "none"; // Ocultar el menú después de seleccionar
});



////////////////// RESTABLECER /////////////////

let restablecer = document.createElement("button");
restablecer.textContent = "R";
restablecer.setAttribute("aria-label", "Restablecer ajustes");
restablecer.setAttribute("title", "Restablecer todos los ajustes");

contenedor.appendChild(restablecer);

restablecer.onclick = function () {
    tamanio = 1; // Restablecer tamaño de la fuente
    cantidadcontraste = 1; // Restablecer contraste
    invertido = false; // Restablecer estado de inversión
    fuenteMenu.selectedIndex = 0; // Restablecer fuente al valor por defecto

    // Aplicar los valores por defecto
    document.querySelector("body").style.fontSize = tamanio + "em";
    document.querySelector("body").style.filter = "contrast(" + cantidadcontraste + ")";
    document.querySelector("body").style.fontFamily = fuentes[0]; // Fuente por defecto
    document.querySelector("body").style.filter = "invert(0) hue-rotate(0deg)";
};
