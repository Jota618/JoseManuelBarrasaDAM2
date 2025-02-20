class JVGrafica {
	constructor(datos, color, selector, titulo) {
	  this.datos = datos; // Datos que se usarán para la gráfica
	  this.color = color; // Color base para la gráfica
	  this.selector = selector; // Selector del contenedor donde se dibujará la gráfica
	  this.titulo = titulo; // Título de la gráfica
	}
  
	tarta() {
	  // Condiciones iniciales
	  let anchura = 512; // Anchura del lienzo
	  let altura = 512; // Altura del lienzo
	  let lienzo = document.createElement("canvas"); // Se crea el lienzo donde se dibujará la gráfica
	  lienzo.width = anchura; // Establece la anchura del lienzo
	  lienzo.height = altura; // Establece la altura del lienzo
	  // lienzo.style.border = "1px solid grey"; // Se puede agregar borde al lienzo si es necesario
	  let contexto = lienzo.getContext("2d"); // Se obtiene el contexto 2D para dibujar sobre el lienzo
	  let variacioncolor = 100; // Variación del color base para los segmentos
	  let micolor = this.hexToRgb("#34495e"); // Color base convertido a RGB
	  let alturaletra = 15; // Altura del texto para la leyenda
  
	  document.querySelector(this.selector).appendChild(lienzo); // Se añade el lienzo al contenedor
  
	  // Cálculo de totales y longitud
	  let total = 0; // Se inicializa el total en cero
	  this.datos.forEach(function(dato) { // Para cada dato de los datos
		total += dato.valor; // Se acumula el valor para obtener el total
	  });
  
	  // Ahora sí, dibujamos los segmentos (quesos)
	  let anguloinicial = 0; // Ángulo inicial, comenzamos desde 0
  
	  this.datos.forEach(function(dato) { // Para cada dato en la lista de datos
		// Generación de color aleatorio dentro del rango de variación
		let r = micolor[0] + Math.round((Math.random() - 0.5) * variacioncolor); // Rojo aleatorio
		let g = micolor[1] + Math.round((Math.random() - 0.5) * variacioncolor); // Verde aleatorio
		let b = micolor[2] + Math.round((Math.random() - 0.5) * variacioncolor); // Azul aleatorio
		let angulofinal = (dato.valor / total) * Math.PI * 2; // Cálculo del ángulo correspondiente a este segmento
		/////////////// Dibujo del "queso"
		contexto.fillStyle = "rgb(" + r + "," + g + "," + b + ")"; // Se establece el color para el segmento
		contexto.beginPath(); // Inicia el camino del dibujo
		contexto.moveTo(anchura / 2, altura / 2); // Mueve el cursor al centro del lienzo
		contexto.arc(
		  anchura / 2,
		  altura / 2,
		  anchura / 2 - 50,
		  anguloinicial,
		  anguloinicial + angulofinal
		); // Dibuja un arco para el segmento
		contexto.lineTo(anchura / 2, altura / 2); // Vuelve al centro
		contexto.fill(); // Rellena el segmento con el color
  
		/////////////// Texto de la leyenda del segmento
		let angulotexto = anguloinicial + angulofinal / 2; // Calcula la posición del texto
		contexto.textAlign = "center"; // Alinea el texto al centro
		contexto.fillStyle = "white"; // Color del texto
		contexto.fillText(
		  dato.texto, // El texto a mostrar
		  anchura / 2 + Math.cos(angulotexto) * (anchura / 2 - 50) / 2, // Calcula la posición X
		  altura / 2 + Math.sin(angulotexto) * (anchura / 2 - 50) / 2 - alturaletra // Calcula la posición Y
		);
  
		/////////////// Texto del valor del segmento
		angulotexto = anguloinicial + angulofinal / 2; // Calcula la nueva posición para el valor
		contexto.fillText(
		  dato.valor, // El valor numérico a mostrar
		  anchura / 2 + Math.cos(angulotexto) * (anchura / 2 - 50) / 2, // Calcula la posición X
		  altura / 2 + Math.sin(angulotexto) * (anchura / 2 - 50) / 2 // Calcula la posición Y
		);
  
		/////////////// Texto del porcentaje del segmento
		angulotexto = anguloinicial + angulofinal / 2; // Ajusta la posición para el porcentaje
		contexto.fillText(
		  (dato.valor / total).toFixed(2) + " %", // Muestra el porcentaje con dos decimales
		  anchura / 2 + Math.cos(angulotexto) * (anchura / 2 - 50) / 2, // Calcula la posición X
		  altura / 2 + Math.sin(angulotexto) * (anchura / 2 - 50) / 2 + alturaletra // Calcula la posición Y
		);
  
		anguloinicial += angulofinal; // Actualiza el ángulo inicial para el siguiente segmento
	  });
	}
  
	anillo() {
	  // Condiciones iniciales
	  let anchura = 512; // Anchura del lienzo
	  let altura = 512; // Altura del lienzo
	  let lienzo = document.createElement("canvas"); // Se crea el lienzo
	  lienzo.width = anchura; // Establece la anchura del lienzo
	  lienzo.height = altura; // Establece la altura del lienzo
	  // lienzo.style.border = "1px solid grey"; // Se puede agregar borde al lienzo si es necesario
	  let contexto = lienzo.getContext("2d"); // Obtiene el contexto 2D para el dibujo
	  let variacioncolor = 100; // Variación del color base para los segmentos
	  let micolor = this.hexToRgb("#34495e"); // Color base convertido a RGB
	  let alturaletra = 20; // Altura de la letra para la leyenda
	  let misupercolor = "#34495e"; // Color principal para el título
	  let misupertitulo = this.titulo; // Título de la gráfica
	  contexto.font = "20px sans-serif"; // Establece el tipo de fuente para el texto
  
	  document.querySelector(this.selector).appendChild(lienzo); // Añade el lienzo al contenedor
  
	  // Cálculo de totales y longitud
	  let total = 0; // Inicializa el total
	  this.datos.forEach(function(dato) { // Recorre todos los datos
		total += dato.valor; // Suma los valores para obtener el total
	  });
  
	  // Ahora sí, dibujamos los segmentos (quesos)
	  let anguloinicial = 0; // Ángulo inicial, comenzamos desde 0
  
	  this.datos.forEach(function(dato) { // Para cada dato en la lista
		// Generación de colores aleatorios
		let r = micolor[0] + Math.round((Math.random() - 0.5) * variacioncolor); // Rojo aleatorio
		let g = micolor[1] + Math.round((Math.random() - 0.5) * variacioncolor); // Verde aleatorio
		let b = micolor[2] + Math.round((Math.random() - 0.5) * variacioncolor); // Azul aleatorio
		let angulofinal = (dato.valor / total) * Math.PI * 2; // Ángulo final del segmento
		/////////////// Dibujo del "queso"
		contexto.fillStyle = "rgb(" + r + "," + g + "," + b + ")"; // Se establece el color del segmento
		contexto.beginPath(); // Comienza el dibujo del segmento
		contexto.moveTo(anchura / 2, altura / 2); // Mueve el cursor al centro
		contexto.arc(
		  anchura / 2,
		  altura / 2,
		  anchura / 2 - 50,
		  anguloinicial,
		  anguloinicial + angulofinal
		); // Dibuja el segmento
		contexto.lineTo(anchura / 2, altura / 2); // Vuelve al centro
		contexto.fill(); // Rellena el segmento con color
  
		/////////////// Texto de la leyenda
		let angulotexto = anguloinicial + angulofinal / 2; // Calcula la posición del texto
		contexto.fillText(
		  dato.texto, // Texto de la leyenda
		  anchura / 2 + Math.cos(angulotexto) * (anchura / 2 + 20) / 2, // Calcula la posición X
		  altura / 2 + Math.sin(angulotexto) * (anchura / 2 + 20) / 2 - alturaletra // Calcula la posición Y
		);
  
		/////////////// Texto del valor
		angulotexto = anguloinicial + angulofinal / 2; // Ajusta la posición para el valor
		contexto.fillText(
		  dato.valor, // Muestra el valor del segmento
		  anchura / 2 + Math.cos(angulotexto) * (anchura / 2 + 20) / 2, // Calcula la posición X
		  altura / 2 + Math.sin(angulotexto) * (anchura / 2 + 20) / 2 // Calcula la posición Y
		);
  
		/////////////// Texto del porcentaje
		angulotexto = anguloinicial + angulofinal / 2; // Ajusta la posición para el porcentaje
		contexto.fillText(
		  (dato.valor / total).toFixed(2) + " %", // Muestra el porcentaje con dos decimales
		  anchura / 2 + Math.cos(angulotexto) * (anchura / 2 + 20) / 2, // Calcula la posición X
		  altura / 2 + Math.sin(angulotexto) * (anchura / 2 + 20) / 2 + alturaletra // Calcula la posición Y
		);
  
		/////////////// Título
		contexto.textAlign = "center"; // Alinea el título al centro
		contexto.fillStyle = misupercolor; // Establece el color del título
		contexto.fillText(misupertitulo, anchura / 2, alturaletra); // Muestra el título
  
		anguloinicial += angulofinal; // Actualiza el ángulo inicial para el siguiente segmento
	  });
	  // Dibuja un círculo blanco en el centro para completar el "anillo"
	  contexto.fillStyle = "white";
	  contexto.beginPath();
	  contexto.arc(anchura / 2, altura / 2, 100, 0, Math.PI * 2);
	  contexto.fill(); // Rellena el círculo
	}
  
	// Método auxiliar para convertir un valor hexadecimal a RGB
	hexToRgb(hex) {
	  // Elimina el '#' si está presente
	  hex = hex.replace(/^#/, '');
  
	  // Convierte el valor hexadecimal a RGB
	  let bigint = parseInt(hex, 16);
	  let r = (bigint >> 16) & 255;
	  let g = (bigint >> 8) & 255;
	  let b = bigint & 255;
  
	  return [r, g, b]; // Devuelve el color en formato RGB
	}
  }
  
