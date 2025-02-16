/**
 * jocarsa-floralwhite - Una biblioteca minimalista para crear diagramas Sankey interactivos con SVG
 * 
 * Autor: Tu Nombre
 * Licencia: MIT (o la que prefieras)
 */

(function (global) {
  const JocarsaFloralwhite = {};

  /**
   * Crear un gráfico Sankey.
   * @param {Object} config - Configuración para el gráfico Sankey
   * @param {string|HTMLElement} config.elemento - Selector o elemento DOM en el que crear el gráfico
   * @param {Object} config.datos - Los datos Sankey: 
   *   {
   *     nodos: [
   *       { nombre: "Nodo A", color: "#xxxxxx" },
   *       { nombre: "Nodo B", color: "#xxxxxx" },
   *       ...
   *     ],
   *     enlaces: [
   *       { origen: "Nodo A", destino: "Nodo B", valor: 10 },
   *       { origen: 1, destino: 2, valor: 15 }, // también se soportan índices numéricos
   *       ...
   *     ]
   *   }
   * @param {number} config.ancho - El ancho total del gráfico
   * @param {number} config.alto - La altura total del gráfico
   * @param {number} [config.anchoNodo=20] - Ancho de cada rectángulo de nodo
   * @param {number} [config.espacioNodo=10] - Espaciado vertical entre nodos
   * @param {boolean} [config.mostrarLeyenda=true] - Si se debe mostrar la leyenda de nodos
   */
  JocarsaFloralwhite.crearGraficoSankey = function(config) {
    const {
      elemento,
      datos,
      ancho,
      alto,
      anchoNodo = 20,
      espacioNodo = 10,
      mostrarLeyenda = true,
    } = config;

    // Resolver el elemento contenedor
    let contenedor;
    if (typeof elemento === 'string') {
      contenedor = document.querySelector(elemento);
    } else {
      contenedor = elemento;
    }
    if (!contenedor) {
      throw new Error("Elemento contenedor no encontrado");
    }

    // Limpiar cualquier contenido existente
    contenedor.innerHTML = '';

    // Crear un SVG
    const svg = crearElementoSVG('svg');
    svg.setAttribute('width', ancho);
    svg.setAttribute('height', alto);
    svg.classList.add('jocarsa-floralwhite-svg');
    contenedor.appendChild(svg);

    // Crear <defs> para los gradientes
    const defs = crearElementoSVG('defs');
    svg.appendChild(defs);

    // Preparar nodos
    const nodos = datos.nodos.map((d, i) => {
      return { 
        indice: i,
        nombre: d.nombre || `Nodo ${i}`,
        color: d.color || obtenerColorAleatorio(),
      };
    });

    // Crear leyenda si se solicita
    if (mostrarLeyenda) {
      crearLeyenda(nodos, contenedor);
    }

    // Construir un mapa de nombre de nodo a índice
    const nombreAIndice = {};
    nodos.forEach((nodo, i) => {
      nombreAIndice[nodo.nombre] = i;
    });

    // Preparar enlaces, mapeando "origen"/"destino" de nombres a índices si es necesario
    const enlaces = datos.enlaces.map(enlace => {
      let indiceOrigen, indiceDestino;

      // Convertir origen si es una cadena
      if (typeof enlace.origen === 'string') {
        indiceOrigen = nombreAIndice[enlace.origen];
        if (indiceOrigen === undefined) {
          throw new Error(`Nodo origen "${enlace.origen}" no encontrado en el array de nodos`);
        }
      } else {
        indiceOrigen = enlace.origen; // asumir que ya es un número
      }

      // Convertir destino si es una cadena
      if (typeof enlace.destino === 'string') {
        indiceDestino = nombreAIndice[enlace.destino];
        if (indiceDestino === undefined) {
          throw new Error(`Nodo destino "${enlace.destino}" no encontrado en el array de nodos`);
        }
      } else {
        indiceDestino = enlace.destino; // asumir que ya es un número
      }

      return {
        origen: indiceOrigen,
        destino: indiceDestino,
        valor: +enlace.valor
      };
    });

    // Construir información de adyacencia y calcular los flujos de entrada/salida
    nodos.forEach(n => {
      n.enlacesOrigen = [];
      n.enlacesDestino = [];
      n.valorEntrada = 0;
      n.valorSalida = 0;
      n.offsetEnlaceSalida = 0; // Inicializar el offset de enlace de salida
      n.offsetEnlaceEntrada = 0;  // Inicializar el offset de enlace de entrada
    });

    enlaces.forEach(enlace => {
      const s = nodos[enlace.origen];
      const t = nodos[enlace.destino];
      s.enlacesOrigen.push(enlace);
      t.enlacesDestino.push(enlace);
      s.valorSalida += enlace.valor;
      t.valorEntrada += enlace.valor;
    });

    // 1) Asignar a cada nodo una "capa" (posición x) de manera simplificada
    const nodosOrigen = nodos.filter(n => n.valorEntrada === 0);
    asignarCapasNodos(nodos, nodosOrigen);

    // 2) Determinar el número total de capas
    const capaMaxima = Math.max(...nodos.map(d => d.capa));
    const totalCapas = capaMaxima + 1;

    // 3) Calcular la posición x de cada nodo en píxeles
    const escalaX = (ancho - anchoNodo) / capaMaxima;
    nodos.forEach(n => {
      n.x0 = n.capa * escalaX;
      n.x1 = n.x0 + anchoNodo;
    });

    // 4) Dentro de cada capa, distribuir los nodos verticalmente.
    const capas = [];
    for (let i = 0; i <= capaMaxima; i++) {
      capas[i] = [];
    }
    nodos.forEach(n => {
      capas[n.capa].push(n);
    });
    capas.forEach(nodosCapa => {
      // Ordenarlos si es necesario
      nodosCapa.sort((a, b) => b.valorSalida - a.valorSalida);
      distribuirNodosCapa(nodosCapa, alto, espacioNodo);
    });

    // 5) Crear los elementos <path> de enlace en el SVG
    enlaces.forEach((enlace, idx) => {
      const origen = nodos[enlace.origen];
      const destino = nodos[enlace.destino];

      // Escalar los anchos de los enlaces para que el total coincida con la altura del nodo
      const escalaAnchoEnlace = (origen.y1 - origen.y0 - (origen.enlacesOrigen.length - 1) * espacioNodo) / 
                               origen.enlacesOrigen.reduce((sum, l) => sum + l.valor, 0);

      const alturaEnlace = enlace.valor * escalaAnchoEnlace;

      // Asignar sy0 y ty0
      const sy0 = origen.y0 + origen.offsetEnlaceSalida + alturaEnlace / 2;
      origen.offsetEnlaceSalida += alturaEnlace + espacioNodo;

      const ty0 = destino.y0 + destino.offsetEnlaceEntrada + alturaEnlace / 2;
      destino.offsetEnlaceEntrada += alturaEnlace + espacioNodo;

      // Crear gradiente si el origen y el destino tienen colores diferentes
      let trazoEnlace;
      if (origen.color === destino.color) {
        trazoEnlace = origen.color;
      } else {
        const idGradiente = `gradiente-${origen.indice}-${destino.indice}-${idx}`;
        const gradienteLineal = crearElementoSVG('linearGradient');
        gradienteLineal.setAttribute('id', idGradiente);
        gradienteLineal.setAttribute('x1', '0%');
        gradienteLineal.setAttribute('y1', '0%');
        gradienteLineal.setAttribute('x2', '100%');
        gradienteLineal.setAttribute('y2', '0%');

        const parada1 = crearElementoSVG('stop');
        parada1.setAttribute('offset', '0%');
        parada1.setAttribute('stop-color', origen.color);
        gradienteLineal.appendChild(parada1);

        const parada2 = crearElementoSVG('stop');
        parada2.setAttribute('offset', '100%');
        parada2.setAttribute('stop-color', destino.color);
        gradienteLineal.appendChild(parada2);

        defs.appendChild(gradienteLineal);

        trazoEnlace = `url(#${idGradiente})`;
      }

      // Crear el path
      const path = crearElementoSVG('path');
      path.setAttribute('class', 'jocarsa-floralwhite-enlace');
      path.setAttribute('d', rutaEnlaceSankey(
        origen.x1, sy0,
        destino.x0, ty0
      ));
      path.setAttribute('stroke', trazoEnlace);
      path.setAttribute('stroke-width', alturaEnlace);
      path.setAttribute('fill', 'none');

      // Interacción de hover
      path.addEventListener('mouseover', () => {
        path.style.strokeOpacity = 0.7;  // o 1 si quieres quitar el desvanecimiento
      });
      path.addEventListener('mouseout', () => {
        path.style.strokeOpacity = 0.2;  // volver a una menor opacidad
      });

      // Opcional: mostrar tooltip o registrar información
      path.addEventListener('click', () => {
        alert(`Enlace: ${origen.nombre} -> ${destino.nombre}\nValor: ${enlace.valor}`);
      });

      svg.appendChild(path);
    });

    // 6) Crear elementos <g> para los nodos
    nodos.forEach(nodo => {
      const g = crearElementoSVG('g');
      g.setAttribute('class', 'jocarsa-floralwhite-nodo');

      const rect = crearElementoSVG('rect');
      rect.setAttribute('x', nodo.x0);
      rect.setAttribute('y', nodo.y0);
      rect.setAttribute('width', anchoNodo);
      rect.setAttribute('height', nodo.y1 - nodo.y0);
      rect.setAttribute('fill', nodo.color);
      rect.setAttribute('stroke', '#ffffff');
      rect.setAttribute('rx', 5);
      rect.setAttribute('ry', 5);
      rect.setAttribute('stroke-width', 2);
      rect.classList.add('jocarsa-floralwhite-rect');

      // Cambiar el relleno a naranja al pasar el ratón
      rect.addEventListener('mouseover', () => {
        rect.style.fill = 'orange';
      });
      rect.addEventListener('mouseout', () => {
        rect.style.fill = nodo.color;
      });

      g.appendChild(rect);

      // Etiqueta del nodo
      const texto = crearElementoSVG('text');
      texto.setAttribute('x', nodo.x0 + anchoNodo / 2);
      texto.setAttribute('y', nodo.y0 + (nodo.y1 - nodo.y0) / 2);
      texto.setAttribute('dy', '0.35em');
      texto.setAttribute('text-anchor', 'middle');
      texto.textContent = nodo.nombre;
      texto.classList.add('jocarsa-floralwhite-text');
      g.appendChild(texto);

      // Opcional: mostrar información al hacer clic
      rect.addEventListener('click', () => {
        alert(`Nodo: ${nodo.nombre}\nEntrada: ${nodo.valorEntrada}\nSalida: ${nodo.valorSalida}`);
      });

      svg.appendChild(g);
    });
  };

  // -------------------------------------------------------------------------
  // Funciones auxiliares
  // -------------------------------------------------------------------------

  function crearLeyenda(nodos, contenedor) {
    const leyenda = document.createElement('div');
    leyenda.classList.add('leyenda-sankey');
    leyenda.style.marginTop = '20px';

    nodos.forEach(nodo => {
      const item = document.createElement('div');
      item.classList.add('leyenda-item');
      item.style.display = 'flex';
      item.style.alignItems = 'center';
      item.style.marginBottom = '5px';

      const colorBox = document.createElement('div');
      colorBox.style.width = '20px';
      colorBox.style.height = '20px';
      colorBox.style.backgroundColor = nodo.color;
      colorBox.style.marginRight = '10px';

      const label = document.createElement('span');
      label.textContent = nodo.nombre;

      item.appendChild(colorBox);
      item.appendChild(label);

      leyenda.appendChild(item);
    });

    contenedor.appendChild(leyenda);
  }

  function asignarCapasNodos(nodos, nodosOrigen) {
    nodos.forEach(n => n.capa = undefined);

    const cola = [];
    nodosOrigen.forEach(s => {
      s.capa = 0;
      cola.push(s);
    });

    while (cola.length) {
      const actual = cola.shift();
      const capaActual = actual.capa;
      actual.enlacesOrigen.forEach(enlace => {
        const nodoDestino = nodos[enlace.destino];
        if (nodoDestino.capa == null || nodoDestino.capa < capaActual + 1) {
          nodoDestino.capa = capaActual + 1;
          cola.push(nodoDestino);
        }
      });
    }
  }

  document.getElementById('filtro-nodo-0').addEventListener('change', (event) => {
    filtrarNodos(nodos, [0]);
  });
  
  
  function exportarComoImagen() {
    const svg = document.querySelector('.jocarsa-floralwhite-svg');
    const svgData = new XMLSerializer().serializeToString(svg);
    const canvas = document.createElement('canvas');
    const ctx = canvas.getContext('2d');
    const image = new Image();
  
    image.onload = () => {
      ctx.drawImage(image, 0, 0);
      const dataURL = canvas.toDataURL('image/png');
      const enlace = document.createElement('a');
      enlace.href = dataURL;
      enlace.download = 'grafico-sankey.png';
      enlace.click();
    };
  
    image.src = 'data:image/svg+xml;base64,' + btoa(svgData);
  }
  
  // Crear un botón para exportar
  const botonExportar = document.createElement('button');
  botonExportar.innerText = 'Exportar como Imagen';
  botonExportar.addEventListener('click', exportarComoImagen);
  document.body.appendChild(botonExportar);
  

  function distribuirNodosCapa(nodosCapa, alturaTotal, espacioNodo) {
    if (!nodosCapa.length) return;
    const valorTotal = nodosCapa.reduce((sum, n) => sum + Math.max(n.valorEntrada, n.valorSalida), 0);
    let yInicio = 0;

    nodosCapa.forEach(n => {
      const valorNodo = Math.max(n.valorEntrada, n.valorSalida);
      const alturaNodo = (valorNodo / valorTotal) * (alturaTotal - espacioNodo * (nodosCapa.length - 1));
      n.y0 = yInicio;
      n.y1 = yInicio + alturaNodo;
      yInicio += alturaNodo + espacioNodo;
    });
  }

  function rutaEnlaceSankey(x0, y0, x1, y1) {
    return `M ${x0} ${y0} C ${x0 + 100} ${y0} ${x1 - 100} ${y1} ${x1} ${y1}`;
  }

  function crearElementoSVG(tag) {
    return document.createElementNS("http://www.w3.org/2000/svg", tag);
  }

  function obtenerColorAleatorio() {
    return `hsl(${Math.random() * 360}, 100%, 50%)`;  // Color aleatorio
  }

  // Exponer la API
  global.jocarsaFloralwhite = JocarsaFloralwhite;
})(this);
