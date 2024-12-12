// Función para manejar imágenes de tamaños dinámicos
const definirDimensiones = (imagen, lienzo) => {
	lienzo.width = imagen.width; // Ajusta el ancho del lienzo según la imagen
	lienzo.height = imagen.height; // Ajusta la altura del lienzo según la imagen
};

// Función para manejar compresión según niveles
const definirNivelCompresion = (coleccion, nivel) => {
	const ajustada = coleccion.map((valor, index) => {
		if (index % 4 !== 3) {
			// Solo aplica a R, G, B
			return Math.floor(valor / nivel) * nivel; // Ajusta el nivel de compresión
		}
		return valor; // Transparencia no se modifica
	});
	return ajustada;
};

// Función para implementar controles de edición de colores
const generarSliders = (lienzo, contexto) => {
	const contenedor = document.createElement("div"); // Contenedor de sliders
	["R", "G", "B"].forEach((color, index) => {
		const slider = document.createElement("input");
		slider.type = "range";
		slider.min = 0;
		slider.max = 255;
		slider.value = 0;
		slider.id = `slider-${color}`;

		const label = document.createElement("label");
		label.innerText = `${color}: `;
		label.appendChild(slider);

		slider.addEventListener("input", () => {
			const datos = contexto.getImageData(0, 0, lienzo.width, lienzo.height);
			const incremento = parseInt(slider.value);

			for (let i = index; i < datos.data.length; i += 4) {
				datos.data[i] = Math.min(255, datos.data[i] + incremento); // Modifica el canal de color
			}

			contexto.putImageData(datos, 0, 0);
		});

		contenedor.appendChild(label);
	});

	document.body.appendChild(contenedor); // Añade el contenedor al DOM
};

// Faltan las funciones de comprimir y descomprimir, aquí tienes un ejemplo básico
const comprimir = (coleccion) => {
	// Un ejemplo simple: solo reduce los valores a un múltiplo de 64
	return definirNivelCompresion(coleccion, 64);
};

const descomprimir = (comprimido) => {
	// Descompresión: en este caso no hace nada, pero puedes implementarlo según la compresión
	return comprimido;
};

// Código principal
const lienzo = document.querySelector("canvas");
const contexto = lienzo.getContext("2d");

let imagen = new Image();
imagen.src = "../need for speed.jpg";
imagen.onload = function () {
	definirDimensiones(imagen, lienzo); // Ajusta dimensiones según la imagen
	contexto.drawImage(imagen, 0, 0);

	let datos = contexto.getImageData(0, 0, lienzo.width, lienzo.height).data;

	console.log("Datos originales:", datos);
	const comprimido = comprimir(definirNivelCompresion(datos, 64)); // Ajusta nivel de compresión
	console.log("Comprimido:", comprimido);

	const descomprimido = descomprimir(comprimido);
	console.log("Descomprimido:", descomprimido);

	let nuevaImagen = contexto.getImageData(0, 0, lienzo.width, lienzo.height);
	for (let i = 0; i < nuevaImagen.data.length; i++) {
		nuevaImagen.data[i] = descomprimido[i];
	}

	contexto.putImageData(nuevaImagen, 0, 0);

	// Generar sliders para edición en tiempo real
	generarSliders(lienzo, contexto);
};
