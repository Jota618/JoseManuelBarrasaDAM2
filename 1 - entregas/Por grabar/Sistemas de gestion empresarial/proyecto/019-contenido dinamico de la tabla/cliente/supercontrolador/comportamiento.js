window.onload = function(){
    /////////////////////////////////// LISTADO DE TABLAS /////////////////////////////////////////////
    
    fetch("../../servidor/lista_tablas.php")                        // LLamo a un microservicio que me da la lista de tablas
        .then(response => {
          return response.json();                                   // Quiero que el servidor me devuelva un json
        })
        .then(datos => {
            let menu = document.querySelector("nav ul")             // Selecciono el menu donde voy a poner las entradas dinamicas
            datos.forEach(function(tabla){                          // Para cada una de las tablas que han venido de la base de datos
                let nombre_de_la_tabla = tabla['Tables_in_crimson'];    // Atrapo el nombre de la tabla que viene del fetch
                let elemento = document.createElement("li")         // Creo en memoria un nuevo elemento li
                elemento.textContent = nombre_de_la_tabla           // A ese elemento li le pongo como texto el nombre de la tabl
                menu.appendChild(elemento)                          // Lo añado al menú
                
            })
        })
    
    /////////////////////////////////// LISTADO DE TABLAS /////////////////////////////////////////////
    
    /////////////////////////////////// LISTADO DE COLUMNAS DE TABLA /////////////////////////////////////////////
    
    fetch("../../servidor/columnas_tabla.php")                              // LLamo a un microservicio que me da la lista de tablas
        .then(response => {
          return response.json();                                           // Quiero que el servidor me devuelva un json
        })
        .then(datos => {
            let cabeceras_tabla = document.querySelector("table thead tr"); // Selecciono donde tengo que poner las cabeceras en la tabla
            datos.forEach(function(dato){                                   // PAra cada uno de los datos
                let elemento = document.createElement("th")                 // Creo un elemento que es una cabecera de tabla
                elemento.textContent = dato['Field']                        // Su texto es el nombre del campo de la base de datos
                cabeceras_tabla.appendChild(elemento)                       // Añado ese elemento a las cabeceras de la tabla
            })
        })
    
    /////////////////////////////////// LISTADO DE COLUMNAS DE TABLA /////////////////////////////////////////////
    
    /////////////////////////////////// CONTENIDO DE LA TABLA /////////////////////////////////////////////
    
    fetch("../../servidor/datos_tabla.php")                                         // LLamo a un microservicio que me da la lista de tablas
        .then(response => {
          return response.json();                                                   // Quiero que el servidor me devuelva un json
        })
        .then(datos => {
            let contenidotabla = document.querySelector("section table tbody")      // Selecciono el contenido vacío de la tabla
            datos.forEach(function(registro){                                       // Como datos es un array, hago un forEach para repasarlo
                let nuevafila = document.createElement("tr")                        // Creo una nueva fila como un elemento html vacio
                Object.keys(registro).forEach(clave => {                            // Fórmula para recorrer correctamente las propiedades de un objeto
                    let nuevacolumna = document.createElement("td")                 // Creo una nueva columna html
                    nuevacolumna.textContent = registro[clave]                      // Le pongo el contenido en texto
                    nuevafila.appendChild(nuevacolumna)                             // Introduzco la columna dentro de la fila
                })
                contenidotabla.appendChild(nuevafila)                               // Introduzco la fila dentro de la tabla
            })
        })
    
    /////////////////////////////////// CONTENIDO DE LA TABLA /////////////////////////////////////////////
}
