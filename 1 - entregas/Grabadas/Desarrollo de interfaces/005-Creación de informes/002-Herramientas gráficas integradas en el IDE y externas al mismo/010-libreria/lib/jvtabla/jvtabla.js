let tablas = document.querySelectorAll(".jvtabla");
 tablas.forEach(function(tabla) {											// Para cada una de las tablas
     let contenido = [];														// Creo un superarray vacio
     // Selecciono cabeceras como índices de array
     let indices = [];															// Creo una lista de indices
     let cabeceras = tabla.querySelectorAll("thead tr th");			// Cargo las cabeceras
     cabeceras.forEach(function(cabecera, colIndex) {								// y para cada cabecera
         indices.push(cabecera.textContent.trim());					// La añado a los indices
         cabecera.onclick = function(){									// Cuando haga click en una cabecera
         	console.log("Vamos a ordenar segun la columna: "+cabecera.textContent)
         	tabla.querySelector("tbody").innerHTML = ""				// Vacio el cuerpo
         	//// Ahora ordeno el array
         	contenido.sort(function(a, b) {								// La funcion sort reordena un array							
         		let valA = a[indices[colIndex]].toLowerCase(); 		// Toma el valor A y lo convierte a minusculas
         		let valB = b[indices[colIndex]].toLowerCase();		// Toma el valor B y lo convierte a minuscilas
         		if (!isNaN(valA) && !isNaN(valB)) { 					// Si los valores son validos
         			valA = parseFloat(valA);								// Los convierte en numero
         			valB = parseFloat(valB);								// Los convierte en numero
         		}
         		return valA > valB ? 1 : valA < valB ? -1 : 0;		// Ejecuta la reordenacion
         	});
         	tabla.querySelector("tbody").innerHTML = "";				// Selecciona el cuerpo de la tabla
         	contenido.forEach(function(linea) {							// Y para cada linea de contenido
         		let fila = document.createElement("tr");				// Crea una nueva fila
         		indices.forEach(function(campo) {						// Y para cada indice (columna)
         			let celda = document.createElement("td");			// Crea una celda
         			celda.textContent = linea[campo];					// Le pone el contenido de texto
         			fila.appendChild(celda);								// Lo añade a la fila
         		});
         		tabla.querySelector("tbody").appendChild(fila);		// Por ultimo añade la fila a la tabla
         	});
         }
     });
     // Ahora vamos con los datos
     let registros = tabla.querySelectorAll("tbody tr");				// Para cada linea del cuerpo
     registros.forEach(function(registro) {								// Recorro
         let linea = {}; // Crear un nuevo objeto en cada iteración	// Creo un objeto vacio
         let celdas = registro.querySelectorAll("td");					// Selecciono las celdas
         celdas.forEach(function(celda, index) {						// Y para cada celda
             linea[indices[index]] = celda.textContent.trim();		// Añado su contenido al array
         });
         contenido.push(linea);												// al superarray le pongo la fila
     });
     console.log(contenido);
 });
