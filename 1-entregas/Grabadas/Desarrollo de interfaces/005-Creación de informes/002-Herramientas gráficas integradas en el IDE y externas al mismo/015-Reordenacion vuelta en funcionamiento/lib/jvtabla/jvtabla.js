let filasPorPagina = 10; // Número de filas por página
let paginaActual = 1; // Página inicial
let tabla = document.querySelector(".jvtabla tbody"); // Cuerpo de la tabla
let contenedorPaginacion = document.getElementById("paginacion"); // Contenedor de paginación

function paginarTabla() {
    let filas = Array.from(tabla.querySelectorAll("tr")); // Todas las filas de la tabla
    let totalFilas = filas.length; // Total de filas
    let totalPaginas = Math.ceil(totalFilas / filasPorPagina); // Total de páginas

    // Ocultar todas las filas
    filas.forEach((fila, index) => {
        if (index >= (paginaActual - 1) * filasPorPagina && index < paginaActual * filasPorPagina) {
            fila.style.display = ""; // Mostrar filas de la página actual
        } else {
            fila.style.display = "none"; // Ocultar las demás filas
        }
    });

    // Generar botones de paginación
    contenedorPaginacion.innerHTML = ""; // Limpiar los botones previos
    for (let i = 1; i <= totalPaginas; i++) {
        let boton = document.createElement("button");
        boton.textContent = i;
        boton.classList.add("boton-pagina");
        if (i === paginaActual) boton.classList.add("activo"); // Resaltar página actual
        boton.addEventListener("click", function () {
            paginaActual = i;
            paginarTabla(); // Actualizar la tabla
        });
        contenedorPaginacion.appendChild(boton);
    }
}

// Llamamos a la función de paginación al inicio
paginarTabla();


let tablas = document.querySelectorAll(".jvtabla");
tablas.forEach(function (tabla) {
    // Para cada una de las tablas
    let contenido = []; // Creo un superarray vacio
    // Selecciono cabeceras como índices de array
    let indices = []; // Creo una lista de indices
    let cabeceras = tabla.querySelectorAll("thead tr th"); // Cargo las cabeceras
    cabeceras.forEach(function (cabecera, colIndex) {
        // y para cada cabecera
        indices.push(cabecera.textContent.trim()); // La añado a los indices
        cabecera.onclick = function () {
            // Cuando haga click en una cabecera
            console.log("Vamos a ordenar segun la columna: " + cabecera.textContent);
            tabla.querySelector("tbody").innerHTML = ""; // Vacio el cuerpo
            //// Ahora ordeno el array
            contenido.sort(function (a, b) {
                // La funcion sort reordena un array
                let valA = a[indices[colIndex]].toLowerCase(); // Toma el valor A y lo convierte a minusculas
                let valB = b[indices[colIndex]].toLowerCase(); // Toma el valor B y lo convierte a minuscilas
                if (!isNaN(valA) && !isNaN(valB)) {
                    // Si los valores son validos
                    valA = parseFloat(valA); // Los convierte en numero
                    valB = parseFloat(valB); // Los convierte en numero
                }
                return valA > valB ? 1 : valA < valB ? -1 : 0; // Ejecuta la reordenacion
            });
            poblarTabla();
        };
    });
    // Ahora vamos con los datos
    let registros = tabla.querySelectorAll("tbody tr"); // Para cada linea del cuerpo
    registros.forEach(function (registro) {
        // Recorro
        let linea = {}; // Crear un nuevo objeto en cada iteración	// Creo un objeto vacio
        let celdas = registro.querySelectorAll("td"); // Selecciono las celdas
        celdas.forEach(function (celda, index) {
            // Y para cada celda
            linea[indices[index]] = celda.textContent.trim(); // Añado su contenido al array
        });
        contenido.push(linea); // al superarray le pongo la fila
    });
    console.log(contenido);
    poblarTabla();

    function poblarTabla() {
        tabla.querySelector("thead tr").innerHTML = "";
        let cabezal1 = document.createElement("th");
        cabezal1.textContent = "magia";
        tabla.querySelector("thead tr").appendChild(cabezal1);
        indices.forEach(function (campo, colIndex) {
            let cabezal = document.createElement("th");
            cabezal.textContent = campo;
            tabla.querySelector("thead tr").appendChild(cabezal);

            cabezal.onclick = function () {
                // Cuando haga click en una cabecera
                console.log("Vamos a ordenar segun la columna: " + cabezal.textContent);
                tabla.querySelector("tbody").innerHTML = ""; // Vacio el cuerpo
                //// Ahora ordeno el array
                contenido.sort(function (a, b) {
                    // La funcion sort reordena un array
                    let valA = a[indices[colIndex]].toLowerCase(); // Toma el valor A y lo convierte a minusculas
                    let valB = b[indices[colIndex]].toLowerCase(); // Toma el valor B y lo convierte a minuscilas
                    if (!isNaN(valA) && !isNaN(valB)) {
                        // Si los valores son validos
                        valA = parseFloat(valA); // Los convierte en numero
                        valB = parseFloat(valB); // Los convierte en numero
                    }
                    return valA > valB ? 1 : valA < valB ? -1 : 0; // Ejecuta la reordenacion
                });
                poblarTabla();
            };
        });
        
        document.getElementById("buscador").addEventListener("input", function () {
    let valorBusqueda = this.value.toLowerCase(); // Texto del buscador en minúsculas
    let filas = document.querySelectorAll(".jvtabla tbody tr"); // Todas las filas del tbody

    filas.forEach(function (fila) {
        let textoFila = fila.textContent.toLowerCase(); // Texto de toda la fila en minúsculas
        if (textoFila.includes(valorBusqueda)) {
            fila.style.display = ""; // Mostrar fila si coincide
        } else {
            fila.style.display = "none"; // Ocultar fila si no coincide
        }
    });
});


        tabla.querySelector("tbody").innerHTML = ""; // Selecciona el cuerpo de la tabla
        let contador = 1;
        contenido.forEach(function (linea) {
            // Y para cada linea de contenido
            let fila = document.createElement("tr"); // Crea una nueva fila
            let celda1 = document.createElement("td"); // Crea una celda
            celda1.textContent = contador; // Le pone el contenido de texto
            fila.appendChild(celda1);
            contador++;
            indices.forEach(function (campo) {
                // Y para cada indice (columna)
                let celda = document.createElement("td"); // Crea una celda
                celda.textContent = linea[campo]; // Le pone el contenido de texto
                fila.appendChild(celda); // Lo añade a la fila
            });
            tabla.querySelector("tbody").appendChild(fila); // Por ultimo añade la fila a la tabla
        });
    }
});
