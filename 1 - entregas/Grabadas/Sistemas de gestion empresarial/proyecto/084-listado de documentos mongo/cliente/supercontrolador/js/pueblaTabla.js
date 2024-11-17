/////////////////////////////////// CREO UNA FUNCIÓN PARA POBLAR EL CONTENIDO DE LAS TABLAS /////////////////////////////////////////////
 
 function pueblaTabla(datos,campoclave,tabla){
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
                nuevacolumna.setAttribute("tabla",tabla)									// Le pongo propiedades personalizadas a la celda
                nuevacolumna.setAttribute("columna",clave)
                nuevacolumna.setAttribute("Identificador",clave_primaria)
                nuevacolumna.ondblclick = function(){										// Comportamiento de cuando hago doble click en la celda
                	console.log("Has hecho click en una celda")
                	this.setAttribute("contenteditable","true")
                	this.focus()
                }
                nuevacolumna.onblur = function(){											// Comportamiento de cuando salgo de la celda
                	this.setAttribute("contenteditable","false")
                	let mensaje = {
                		"tabla":this.getAttribute("tabla"),
                		"columna":this.getAttribute("columna"),
                		"Identificador":this.getAttribute("Identificador"),
                		"valor":this.textContent
                	}																					// En el mensaje recopilo los datos que le he puesto a la celda
                	fetch("../../servidor/?o=actualizar", {							// Ahora realizo una peticion al servidor y le paso el objeto
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
					  	console.log(datos)
					  })
                	console.log(mensaje)
                }
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
