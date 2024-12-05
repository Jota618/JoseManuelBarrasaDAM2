function comprimir(coleccion) {
	// Quitamos la transparencia y convertimos RGB a un solo valor
	const sintransparencia = [];
	for (let i = 0; i < coleccion.length; i += 4) {
		const rojo = coleccion[i];
		const verde = coleccion[i + 1];
		const azul = coleccion[i + 2];
		sintransparencia.push((rojo << 16) + (verde << 8) + azul);
	}

	// Compresión RLE
	const comprimido = rleCompressArray(sintransparencia);
	return comprimido;
}

function descomprimir(coleccion) {
	// Descompresión RLE
	const desrle = rleDecompressArray(coleccion);
	const descomprimido = new Uint8ClampedArray(desrle.length * 4);

	let j = 0;
	for (let i = 0; i < desrle.length; i++) {
		// Reconstruimos los colores R, G, B y añadimos transparencia
		descomprimido[j++] = (desrle[i] >> 16) & 255; // Rojo
		descomprimido[j++] = (desrle[i] >> 8) & 255;  // Verde
		descomprimido[j++] = desrle[i] & 255;         // Azul
		descomprimido[j++] = 255;                     // Transparencia fija
	}
	return descomprimido;
}

function rleCompressArray(arr) {
	const compressed = [];
	let count = 1;
	for (let i = 1; i < arr.length; i++) {
		if (arr[i] === arr[i - 1]) {
			count++;
		} else {
			compressed.push([arr[i - 1], count]);
			count = 1;
		}
	}
	compressed.push([arr[arr.length - 1], count]);
	return compressed;
}

function rleDecompressArray(compressed) {
	const decompressed = [];
	for (let i = 0; i < compressed.length; i++) {
		const [value, count] = compressed[i];
		for (let j = 0; j < count; j++) {
			decompressed.push(value);
		}
	}
	return decompressed;
}

