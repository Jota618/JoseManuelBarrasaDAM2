/////////////////////////////////// VARIABLES GLOBALES DEL PROGRAMA /////////////////////////////////////////////

var columnas_tabla = []                                             // Creo una variable global para almacenar las columnas

/////////////////////////////////// VARIABLES GLOBALES DEL PROGRAMA /////////////////////////////////////////////

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
                elemento.onclick = function(){                      // Cuando hago click en los elementos de la tabla
                    let texto = this.textContent                    // Atrapo el texto del elemento de navegacion
                    cargaDatosTabla(texto)                          // Y lo paso como parametro a la llamada que carga los datos de la tabla
                }
                menu.appendChild(elemento)                          // Lo añado al menú
                
            })
        })
    
    /////////////////////////////////// LISTADO DE TABLAS /////////////////////////////////////////////
     
    cargaDatosTabla("clientes")                                 // Cuando arranca el programa, le pongo una tabla por defecto
    
    /////////////////////////////////// CLICK VENTANA MODAL PARA INSERTAR /////////////////////////////////////////////
    
    document.querySelector("#insertar").onclick = function(){
        document.querySelector("#modal").style.display = "block"
    }
    document.querySelector("#modal").onclick = function(){
        document.querySelector("#modal").style.display = "none"
    }
    document.querySelector("#contienemodal").onclick = function(event){
        event.stopPropagation()
    }
}

/////////////////////////////////// CREO UNA FUNCIÓN PARA CARGAR DINÁMICAMENTE TABLAS /////////////////////////////////////////////

function cargaDatosTabla(tabla){
   let campoclave;                                                          // Creo  una variable que va a almacenar el nombre del campo que es clave primaria
   /////////////////////////////////// LISTADO DE COLUMNAS DE TABLA /////////////////////////////////////////////
    
    fetch("../../servidor/columnas_tabla.php?tabla="+tabla)                 // LLamo a un microservicio que me da la lista de tablas y le paso la tabla como parametro
        .then(response => {
          return response.json();                                           // Quiero que el servidor me devuelva un json
        })
        .then(datos => {
            columnas_tabla = []                                             // Vacía las columnas anteriores para cargar solo las nuevas
            let cabeceras_tabla = document.querySelector("table thead tr"); // Selecciono donde tengo que poner las cabeceras en la tabla
            cabeceras_tabla.innerHTML = ""                                  // Por si acaso hay columnas previamente cargadas, vacio la cabecera
            datos.forEach(function(dato){                                   // PAra cada uno de los datos
                let elemento = document.createElement("th")                 // Creo un elemento que es una cabecera de tabla
                columnas_tabla.push(dato['Field'])                          // Al listado de columnas le añades la columna actual
                elemento.textContent = dato['Field']                        // Su texto es el nombre del campo de la base de datos
                cabeceras_tabla.appendChild(elemento)                       // Añado ese elemento a las cabeceras de la tabla
                if(dato['Key'] == "PRI"){                                   // Si este campo es clave primaria
                    campoclave = dato['Field']                              // en ese caso, recordamos cual es el nombre del campo que hace de clave primaria
                }
            })
            let elemento = document.createElement("th") 
            cabeceras_tabla.appendChild(elemento) 
            console.log(columnas_tabla);
            
                /////////////////////////////////// LISTADO DE COLUMNAS DE TABLA /////////////////////////////////////////////
                let coleccioncampos = []                                                                // Creo una colección vacía de campos
                let contiene_modal = document.querySelector("#contienemodal")                           // Selecciono el contenedor del modal
                contiene_modal.innerHTML = "<h1>Formulario de inserción: "+tabla+"</h1>"                                                           // Si el modal contenía algo, lo vaćio
                let seccion = document.createElement("section")
                columnas_tabla.forEach(function(columna){                                               // PAra cada una de las columnas de la tabla
                    let contenedor = document.createElement("div")
                    let texto = document.createElement("p")
                    texto.textContent = "Inserta un nuevo elemento para: "+columna+""
                    contenedor.appendChild(texto)
                    coleccioncampos.push(document.createElement("input"))                               // Creo un campo input
                    coleccioncampos[coleccioncampos.length-1].setAttribute("placeholder",columna)                                           // Le pongo una leyenda al campo                                  
                    contenedor.appendChild(coleccioncampos[coleccioncampos.length-1])                                                    // Lo añado al modal
                    seccion.appendChild(contenedor)                                                    // Lo añado al modal
                })
                contiene_modal.appendChild(seccion) 
                
                let boton_enviar = document.createElement("button")                                     // Por último creo un boton
                boton_enviar.textContent = "Enviar"                                                     // Le pongo texto al boton
                boton_enviar.onclick = function(){                                                      // Cuando haga click en el boton
                    console.log("Vamos a procesar el formulario")                                       // Saco un mensaje
                    console.log(coleccioncampos)
                    let mensaje = {}
                    coleccioncampos.forEach(function(campo){
                        mensaje[campo.getAttribute('placeholder')] = campo.value
                    })
                    console.log(mensaje)
                }
                contienemodal.appendChild(boton_enviar)                                                 // Añado el boton al modal
                /////////////////////////////////// LISTADO DE COLUMNAS DE TABLA /////////////////////////////////////////////
            
            /////////////////////////////////// CONTENIDO DE LA TABLA /////////////////////////////////////////////
 
            fetch("../../servidor/datos_tabla.php?tabla="+tabla)                            // LLamo a un microservicio que me da la lista de tablas y le paso la tabla como parametro
                .then(response => {
                  return response.json();                                                   // Quiero que el servidor me devuelva un json
                })
                .then(datos => {
                    let contenidotabla = document.querySelector("section table tbody")      // Selecciono el contenido vacío de la tabla
                    contenidotabla.innerHTML = ""                                           // Vacio la tabla por si habia algo
                    
                    datos.forEach(function(registro){                                       // Como datos es un array, hago un forEach para repasarlo
                        let clave_primaria;
                        let nuevafila = document.createElement("tr")                        // Creo una nueva fila como un elemento html vacio
                        Object.keys(registro).forEach(clave => {                            // Fórmula para recorrer correctamente las propiedades de un objeto
                            if(clave == campoclave){                                        // Si este campo que estoy viendo ahora mismo es ademas la clave primaria
                                clave_primaria = registro[clave]                            // Pues guarda el numero de la clave primaria como identificador de registro
                            }
                            let nuevacolumna = document.createElement("td")                 // Creo una nueva columna html
                            nuevacolumna.textContent = registro[clave]                      // Le pongo el contenido en texto
                            nuevafila.appendChild(nuevacolumna)                             // Introduzco la columna dentro de la fila
                        })
                        let nuevacolumna = document.createElement("td")                     // Creo una nueva columna
                        nuevacolumna.textContent = "🗑️"                                     // Le doy el emoji de la papelera
                        nuevacolumna.setAttribute("claveprimaria",clave_primaria)           // Ademas le pongo un atributo que se llama claveprimaria y le pongo el valor correspondiente
                        nuevafila.appendChild(nuevacolumna)                                 // Lo pongo en las columnas
                        nuevacolumna.onclick = function(){                                  // Cuando haga click en la papelera
                            console.log("Vamos a eliminar algo")                            // Vamos a eliminar algo
                            let identificador = this.getAttribute("claveprimaria")          // tomo el identificador
                            fetch("../../servidor/eliminar_dato.php?tabla="+tabla+"&id="+identificador)     // Hago una petición a un microservicio para eliminar un registro
                            this.parentElement.remove()                                     // Ademas de enviar la peticion al servidor, elimino visualmente el elemento
                        }
                        contenidotabla.appendChild(nuevafila)                               // Introduzco la fila dentro de la tabla
                    })
                })
           
            /////////////////////////////////// CONTENIDO DE LA TABLA /////////////////////////////////////////////
            
            
            /////////////////////////////////// CONTENIDO DE LA VENTANA MODAL /////////////////////////////////////////////
        })
    
 }
 
 /////////////////////////////////// CREO UNA FUNCIÓN PARA CARGAR DINÁMICAMENTE TABLAS /////////////////////////////////////////////
