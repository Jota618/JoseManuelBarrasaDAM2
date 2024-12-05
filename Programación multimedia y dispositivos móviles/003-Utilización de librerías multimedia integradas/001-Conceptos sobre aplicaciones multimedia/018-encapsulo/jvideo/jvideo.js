


window.onload = function(){										// ME espero a que todo en la web haya cargado
	let videos = document.querySelectorAll("video")			// Selecciono todos los videos que me encuentre en la web
	videos.forEach(function(video){								// Para cada uno de los videos que me encuentre
		
		let volumen = 1.0
		
		let tagvideo = video											// Meto el video en la memoria
		let contienevideo = document.createElement("div")	// Creo un contenedor
		contienevideo.classList.add("jvideo")					// Al contenedor le añado una clase
		tagvideo.replaceWith(contienevideo);					// Reemplazo el video con el contenedor
		contienevideo.appendChild(tagvideo)						// Añado el contenedor de video al DOM
		
		let barracontroles = document.createElement("div")
		barracontroles.classList.add("barracontroles")
		contienevideo.appendChild(barracontroles)
		
		let barraprogreso = document.createElement("div")
		barraprogreso.classList.add("barraprogreso")
		contienevideo.appendChild(barraprogreso)
		
		let progreso = document.createElement("div")
		progreso.classList.add("progreso")
		barraprogreso.appendChild(progreso)
		
		tagvideo.addEventListener('timeupdate', () => {
		 	let actual = tagvideo.currentTime
		 	let total = tagvideo.duration
		 	let porcentaje = (actual/total)*100
		 	progreso.style.width = porcentaje+"%"
	  	});
	
		/*////////////////////// BOTÓN DE PLAY //////////////////////*/
		
		let botonplay = document.createElement("button")	// Creo un boton
		botonplay.innerHTML = "<img src='play.svg'>"								// Le pongo el icono
		barracontroles.appendChild(botonplay)					// Lo añado al contenedor
		let estado = "pause"											// Defino el estado original del reproductor
		botonplay.onclick = function(){							// Cuando haga click en el boton de play
			playopausa()
		}
		
		/*////////////////////// BOTÓN DE VOLUMEN MAS //////////////////////*/
		
		let botonvolumenmas = document.createElement("button")	// Creo un boton
		botonvolumenmas.innerHTML = "<img src='volumenmas.svg'>"								// Le pongo el icono
		barracontroles.appendChild(botonvolumenmas)					// Lo añado al contenedor
		
		botonvolumenmas.onclick = function(){							// Cuando haga click en el boton de play
			if(tagvideo.volume < 1.0){
				tagvideo.volume += 0.1
			}
		}
		
		/*////////////////////// BOTÓN DE VOLUMEN MENOS //////////////////////*/
		
		let botonvolumenmenos = document.createElement("button")	// Creo un boton
		botonvolumenmenos.innerHTML = "<img src='volumenmenos.svg'>"								// Le pongo el icono
		barracontroles.appendChild(botonvolumenmenos)					// Lo añado al contenedor
		
		botonvolumenmenos.onclick = function(){							// Cuando haga click en el boton de play
			if(tagvideo.volume > 0.0){
				tagvideo.volume -= 0.1
			}
		}
		
		/*////////////////////// CONTROL DE VOLUMEN //////////////////////*/
		
		let controlvolumen = document.createElement("input")
		controlvolumen.setAttribute("type","range")
		contienevideo.appendChild(controlvolumen)
		controlvolumen.onchange = function(){
			console.log(this.value)
			tagvideo.volume = this.value/100
		}
		
		
		
		/*////////////////////// BOTÓN DE RETROCEDER //////////////////////*/
		
		let botonretroceder = document.createElement("button")	// Creo un boton
		botonretroceder.innerHTML = "<img src='retroceder.svg'>"								// Le pongo el icono
		barracontroles.appendChild(botonretroceder)					// Lo añado al contenedor
		
		botonretroceder.onclick = function(){							// Cuando haga click en el boton de play
			tagvideo.currentTime -= 10
		}
		
		/*////////////////////// BOTÓN DE AVANZAR //////////////////////*/
		
		let botonavanzar = document.createElement("button")	// Creo un boton
		botonavanzar.innerHTML = "<img src='avanzar.svg'>"								// Le pongo el icono
		barracontroles.appendChild(botonavanzar)					// Lo añado al contenedor
		
		botonavanzar.onclick = function(){							// Cuando haga click en el boton de play
			tagvideo.currentTime += 10
		}
		
		/*////////////////////// CLICK EN EL VIDEO //////////////////////*/
		
		tagvideo.onclick = function(){
			playopausa()
		}
		
		function playopausa(){
			if(estado == "pause"){									// En el caso de que esté en pausa
				botonplay.innerHTML = "<img src='pause.svg'>"							// Le pongo el boton de pausa
				estado = "play"										// Cambio el estado
				tagvideo.play()										// Reproduzco el video
			}else{														// En caso contrario
				botonplay.innerHTML = "<img src='play.svg'>"							// Le pongo el icono de play
				estado = "pause"										// Le cambio el estado
				tagvideo.pause()										// Pauso el video
			}
		}
	})
}
