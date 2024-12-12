function comprimir(coleccion){
		
			//////////////////////	PRIMERO QUITO LA TRANSPARENCIA	//////////////////////
			
			const sintransparencia = []																				// Creo un array vacio
			for(let i = 0;i<coleccion.length;i+=4){																// Para cada pixel
				sintransparencia.push(coleccion[i]*255*255+coleccion[i+1]*255+coleccion[i+2])			// descarto la transparencia y unifico
			}
			
			//////////////////////	LUEGO COMPRIMO RLE	//////////////////////
			
			const comprimido = rleCompressArray(sintransparencia)
			
			return comprimido
		}
		
		function descomprimir(coleccion) {
			 const desrle = rleDecompressArray(coleccion);
			 const descomprimido = new Uint8ClampedArray(desrle.length * 4); // Multiplicamos por 4 para RGBA
			 let j = 0;

			 for (let i = 0; i < desrle.length; i++) {
				  descomprimido[j++] = (desrle[i] >> 16) & 255;  // Rojo
				  descomprimido[j++] = (desrle[i] >> 8) & 255;   // Verde
				  descomprimido[j++] = desrle[i] & 255;          // Azul
				  descomprimido[j++] = 255;                      // Transparencia fija
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
		
		function insertar(arr, element) {
			 for (let i = 3; i < arr.length; i += 4) {
				  arr.splice(i, 0, element);
				  i++; 
			 }
			 return arr;
		}
