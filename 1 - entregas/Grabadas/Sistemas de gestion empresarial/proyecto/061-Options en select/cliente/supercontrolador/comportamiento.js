/////////////////////////////////// VARIABLES GLOBALES DEL PROGRAMA /////////////////////////////////////////////

var columnas_tabla = []                                             // Creo una variable global para almacenar las columnas

/////////////////////////////////// VARIABLES GLOBALES DEL PROGRAMA /////////////////////////////////////////////

window.onload = function(){
    /////////////////////////////////// LISTADO DE TABLAS /////////////////////////////////////////////
    
    fetch("../../servidor/?o=listatablas")                        // LLamo a un microservicio que me da la lista de tablas
        .then(response => {
          return response.json();                                   // Quiero que el servidor me devuelva un json
        })
        .then(datos => {
        console.log(datos)
            let menu = document.querySelector("nav ul")             // Selecciono el menu donde voy a poner las entradas dinamicas
            datos.forEach(function(tabla){                          // Para cada una de las tablas que han venido de la base de datos
                let nombre_de_la_tabla = tabla['Tables_in_crimson'];    // Atrapo el nombre de la tabla que viene del fetch
                let elemento = document.createElement("li")         // Creo en memoria un nuevo elemento li
                elemento.textContent = nombre_de_la_tabla           // A ese elemento li le pongo como texto el nombre de la tabl
                elemento.setAttribute("comentario",tabla['Comentario'])
                elemento.onclick = function(){                      // Cuando hago click en los elementos de la tabla
                    let texto = this.textContent                    // Atrapo el texto del elemento de navegacion
                    cargaDatosTabla(texto)                          // Y lo paso como parametro a la llamada que carga los datos de la tabla
                    document.querySelector(".titulotabla h5").textContent = this.textContent
                    document.querySelector(".titulotabla p").textContent = this.getAttribute("comentario")
                    // Primero voy a quitar todas las clases
                    let elementosmenu = document.querySelectorAll("nav ul li")
                    elementosmenu.forEach(function(elemento){           // PAra cada uno de los elementos del menu
                        elemento.classList.remove("menuseleccionado")
                    })
                    
                    this.classList.add("menuseleccionado")
                }
                menu.appendChild(elemento)                          // Lo añado al menú
                
            })
        })
    
    /////////////////////////////////// LISTADO DE TABLAS /////////////////////////////////////////////
     
    cargaDatosTabla("clientes")                                 // Cuando arranca el programa, le pongo una tabla por defecto
    
    /////////////////////////////////// CLICK VENTANA MODAL PARA INSERTAR /////////////////////////////////////////////
    
    document.querySelector("#insertar").onclick = function(){
        document.querySelector("#modal").style.display = "block"
        document.querySelector("#modal").classList.remove("desaparece")
        document.querySelector("#modal").classList.add("aparece")
    }
    document.querySelector("#modal").onclick = function(){
        
        document.querySelector("#modal").classList.remove("aparece")
        document.querySelector("#modal").classList.add("desaparece")
        setTimeout(function(){
            document.querySelector("#modal").style.display = "none"
        },1000)
    }
    document.querySelector("#contienemodal").onclick = function(event){
        event.stopPropagation()
    }
}

/////////////////////////////////// CREO UNA FUNCIÓN PARA CARGAR DINÁMICAMENTE TABLAS /////////////////////////////////////////////

function cargaDatosTabla(tabla){
   let campoclave;                                                          // Creo  una variable que va a almacenar el nombre del campo que es clave primaria
   /////////////////////////////////// LISTADO DE COLUMNAS DE TABLA /////////////////////////////////////////////
    
    fetch("../../servidor/?o=columnastabla&tabla="+tabla)                 // LLamo a un microservicio que me da la lista de tablas y le paso la tabla como parametro
        .then(response => {
          return response.json();                                           // Quiero que el servidor me devuelva un json
        })
        .then(datos => {
            columnas_tabla = []                                             // Vacía las columnas anteriores para cargar solo las nuevas
            tipos_tabla = []																// Creo un array vacio para almacenar los tipos de dato de las colummnas de la tabla
            claves_tabla = []																// Creo un array vacio para almacenar el tipo de clave de cada columna de la tabla
            campos_busqueda = []															// Creo un array vacio para almacenar los input del buscador de la tabla
            let cabeceras_tabla = document.querySelector("table thead tr"); // Selecciono donde tengo que poner las cabeceras en la tabla
            cabeceras_tabla.innerHTML = ""                                  // Por si acaso hay columnas previamente cargadas, vacio la cabecera
            datos.forEach(function(dato){                                   // PAra cada uno de los datos
                let elemento = document.createElement("th")                 // Creo un elemento que es una cabecera de tabla
                columnas_tabla.push(dato['Field'])                          // Al listado de columnas le añades la columna actual
                 
                elemento.textContent = dato['Field']                        // Su texto es el nombre del campo de la base de datos
                campos_busqueda.push(document.createElement("input"))											// Creo un elemento de tipo input html
                campos_busqueda[campos_busqueda.length-1].setAttribute("placeholder",dato['Field'] )	// A cada uno de los campos del buscador les pongo un placeholder
                
                claves_tabla.push(dato['Key'])										// Al array de claves le añado el valor de la clave que viene de la base de datos
                
                console.log(dato['Type'])
                if(dato['Type'].includes("varchar")){														// Si el tipo de dato incluye varchar
                	campos_busqueda[campos_busqueda.length-1].setAttribute("type","text" )		// El tipo de campo es text
                	tipos_tabla.push("text")																	// y le sumo el valor correspondiente al array
                }else if(dato['Type'].includes("int")){														// Si el tipo de dato incluye int
                	campos_busqueda[campos_busqueda.length-1].setAttribute("type","number" )		// El tipo de campo es numerico
                	tipos_tabla.push("number")
                }else if(dato['Type'].includes("date")){														// Si el tipo de dato incluye fecha
                	campos_busqueda[campos_busqueda.length-1].setAttribute("type","date" )		// El tipo de campo es date
                	tipos_tabla.push("date")
                }else if(dato['Type'].includes("decimal")){														// Si el tipo de dato incluye decimal
                	campos_busqueda[campos_busqueda.length-1].setAttribute("type","number" )		// El tipo de campo es number
                	tipos_tabla.push("number")
                }
                
                elemento.appendChild(campos_busqueda[campos_busqueda.length-1])											// En cada una de las cabeceras, pongo un campo input
                cabeceras_tabla.appendChild(elemento)                       // Añado ese elemento a las cabeceras de la tabla
                if(dato['Key'] == "PRI"){                                   // Si este campo es clave primaria
                    campoclave = dato['Field']                              // en ese caso, recordamos cual es el nombre del campo que hace de clave primaria
                }
            })
            let elemento = document.createElement("th") 							// Creo una columna mas en la tabla
            elemento.textContent = "🔍"												// En la ultima cabecera de columna pongo la lupa
            cabeceras_tabla.appendChild(elemento) 									// Lo añado a las cabeceras de la tabla
            elemento.onclick = function(){											// Cuando haga click en la lupa

            	mensaje = {}																// Creo un objeto vacio
            	campos_busqueda.forEach(function(campo){							// Para cada uno de los input de busqueda
            		let columna = campo.getAttribute("placeholder")				// Atrapo el nombre del campo
            		let valor = campo.value												// Atrapo el valor del campo
            		if(valor != ""){														// Si el campo no está vacio
            			mensaje[columna] = valor										// Le añado el dato al objeto
            		}
            	})
            	fetch("../../servidor/?o=buscarSimilar&tabla="+tabla, {		// Ahora realizo una peticion al servidor y le paso el objeto
                          method: 'POST', 
                          headers: {
                            'Content-Type': 'application/json', 
                          },
                          body: JSON.stringify(mensaje), 
                        })
					  .then(response => {
						 return response.json();                                                       // Quiero que el servidor me devuelva un json
					  })
					  .then(datos => {			  
					  		pueblaTabla(datos,campoclave)									// Cuando el servidor me responde, pueblo la tabla con los datos que han venido
					  })
            }
            console.log(columnas_tabla);
            
                /////////////////////////////////// LISTADO DE COLUMNAS DE TABLA /////////////////////////////////////////////
                let coleccioncampos = []                                                                // Creo una colección vacía de campos
                let contiene_modal = document.querySelector("#contienemodal")                           // Selecciono el contenedor del modal
                contiene_modal.innerHTML = "<h1>Formulario de inserción: "+tabla+"</h1>"                                                           // Si el modal contenía algo, lo vaćio
                let seccion = document.createElement("section")
                columnas_tabla.forEach(function(columna,index){                                               // PAra cada una de las columnas de la tabla
                    let contenedor = document.createElement("div")
                    let texto = document.createElement("p")
                    texto.textContent = "Inserta un nuevo elemento para: "+columna+""
                    contenedor.appendChild(texto)
                    if(claves_tabla[index] != "MUL"){
		                 coleccioncampos.push(document.createElement("input"))                               // Creo un campo input
		                 coleccioncampos[coleccioncampos.length-1].setAttribute("type",tipos_tabla[index]) 
		                 coleccioncampos[coleccioncampos.length-1].setAttribute("placeholder",columna)                                           // Le pongo una leyenda al campo                                  
                    
                    }else{
                    		coleccioncampos.push(document.createElement("select")) 
                    		let opcion = document.createElement("option")
                    		opcion.textContent = "Selecciona una opción:"
                    		coleccioncampos[coleccioncampos.length-1].appendChild(opcion)
                    		fetch("../../servidor/?o=tabla&tabla="+columna.split("_")[0])
                    		.then(function(response){
                    			return response.json()
                    		})
                    		.then(function(datos){
                    			console.log(datos)
                    			datos.forEach(function(dato){
                    				let opcion = document.createElement("option")
                    				let cadena = Object.values(dato).join(' - ');
                    				opcion.textContent = cadena
                    				coleccioncampos[coleccioncampos.length-1].appendChild(opcion)
                    			})
                    		})
                    }                                                   // Lo añado al modal
                    contenedor.appendChild(coleccioncampos[coleccioncampos.length-1]) 
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
                        if(campo.getAttribute('placeholder') != "Identificador"){
                            mensaje[campo.getAttribute('placeholder')] = campo.value
                        }
                    })
                    console.log(mensaje)
                    fetch("../../servidor/?o=insertar&tabla="+tabla, {
                          method: 'POST', 
                          headers: {
                            'Content-Type': 'application/json', 
                          },
                          body: JSON.stringify(mensaje), 
                        })
                    .then(function(response){
                        return response.text()
                    })
                    .then(function(datos){
                        console.log(datos)
                        document.querySelector("#modal").classList.remove("aparece")
                        document.querySelector("#modal").classList.add("desaparece")
                        setTimeout(function(){
                            document.querySelector("#modal").style.display = "none"
                        },1000)
                    })
                    
                }
                contienemodal.appendChild(boton_enviar)                                                 // Añado el boton al modal
                /////////////////////////////////// LISTADO DE COLUMNAS DE TABLA /////////////////////////////////////////////
            
            /////////////////////////////////// CONTENIDO DE LA TABLA /////////////////////////////////////////////
 
            fetch("../../servidor/?o=tabla&tabla="+tabla)                            // LLamo a un microservicio que me da la lista de tablas y le paso la tabla como parametro
                .then(response => {
                  return response.json();                                                   // Quiero que el servidor me devuelva un json
                })
                .then(datos => {
                    pueblaTabla(datos,campoclave)
                })
           
            /////////////////////////////////// CONTENIDO DE LA TABLA /////////////////////////////////////////////
            
            
            /////////////////////////////////// CONTENIDO DE LA VENTANA MODAL /////////////////////////////////////////////
        })
    
 }
 
 /////////////////////////////////// CREO UNA FUNCIÓN PARA CARGAR DINÁMICAMENTE TABLAS /////////////////////////////////////////////
 
 
 
 /////////////////////////////////// CREO UNA FUNCIÓN PARA POBLAR EL CONTENIDO DE LAS TABLAS /////////////////////////////////////////////
 
 function pueblaTabla(datos,campoclave){
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
                fetch("../../servidor/?o=eliminar&tabla="+tabla+"&id="+identificador)     // Hago una petición a un microservicio para eliminar un registro
                this.parentElement.remove()                                     // Ademas de enviar la peticion al servidor, elimino visualmente el elemento
            }
            contenidotabla.appendChild(nuevafila)                               // Introduzco la fila dentro de la tabla
        })
                    
 }
  /////////////////////////////////// CREO UNA FUNCIÓN PARA POBLAR EL CONTENIDO DE LAS TABLAS /////////////////////////////////////////////
