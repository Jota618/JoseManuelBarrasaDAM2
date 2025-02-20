document.addEventListener("DOMContentLoaded", () => {
	const videos = document.querySelectorAll("video");

	videos.forEach(video => {
		const volumenInicial = 1.0;
		const contenedorVideo = document.createElement("div");
		contenedorVideo.className = "jvideo";
		video.replaceWith(contenedorVideo);
		contenedorVideo.appendChild(video);

		const controles = crearControles(video, volumenInicial);
		const barraProgreso = crearBarraProgreso(video);
		contenedorVideo.append(controles, barraProgreso);
	});
});

function crearControles(video, volumenInicial) {
	const controles = document.createElement("div");
	controles.className = "barracontroles";

	const botones = [
		{ icono: "play.svg", accion: () => togglePlay(video) },
		{ icono: "volumenmas.svg", accion: () => ajustarVolumen(video, 0.1) },
		{ icono: "volumenmenos.svg", accion: () => ajustarVolumen(video, -0.1) },
		{ icono: "retroceder.svg", accion: () => ajustarTiempo(video, -10) },
		{ icono: "avanzar.svg", accion: () => ajustarTiempo(video, 10) },
		{ icono: "pantalla-completa.png", accion: () => pantallaCompleta(video) },
		{ icono: "mute.jpg", accion: () => toggleMute(video) }
	];

	botones.forEach(({ icono, accion }) => {
		const boton = document.createElement("button");
		boton.innerHTML = `<img src='${icono}'>`;
		boton.onclick = accion;
		controles.appendChild(boton);
	});

	const selectorVelocidad = crearSelectorVelocidad(video);
	const indicadorTiempo = crearIndicadorTiempo(video);

	const controlVolumen = document.createElement("input");
	controlVolumen.type = "range";
	controlVolumen.value = volumenInicial * 100;
	controlVolumen.oninput = () => (video.volume = controlVolumen.value / 100);

	controles.append(selectorVelocidad, indicadorTiempo, controlVolumen);

	return controles;
}

function crearBarraProgreso(video) {
	const barraProgreso = document.createElement("div");
	barraProgreso.className = "barraprogreso";

	const progreso = document.createElement("div");
	progreso.className = "progreso";
	barraProgreso.appendChild(progreso);

	video.addEventListener("timeupdate", () => {
		const porcentaje = (video.currentTime / video.duration) * 100;
		progreso.style.width = `${porcentaje}%`;
	});

	barraProgreso.onclick = e => {
		const { left, width } = barraProgreso.getBoundingClientRect();
		const nuevoTiempo = ((e.clientX - left) / width) * video.duration;
		video.currentTime = nuevoTiempo;
	};

	return barraProgreso;
}

function crearSelectorVelocidad(video) {
	const selector = document.createElement("select");
	[0.5, 1, 1.5, 2].forEach(vel => {
		const opcion = document.createElement("option");
		opcion.value = vel;
		opcion.textContent = `${vel}x`;
		selector.appendChild(opcion);
	});
	selector.onchange = () => (video.playbackRate = parseFloat(selector.value));
	return selector;
}

function crearIndicadorTiempo(video) {
	const tiempo = document.createElement("div");
	tiempo.className = "tiempo";

	video.addEventListener("timeupdate", () => {
		const formato = segundos => {
			const minutos = Math.floor(segundos / 60);
			const segundosRestantes = Math.floor(segundos % 60);
			return `${minutos}:${segundosRestantes < 10 ? "0" : ""}${segundosRestantes}`;
		};
		tiempo.textContent = `${formato(video.currentTime)} / ${formato(video.duration)}`;
	});

	return tiempo;
}

function togglePlay(video) {
	if (video.paused) {
		video.play();
	} else {
		video.pause();
	}
}

function ajustarVolumen(video, delta) {
	video.volume = Math.min(1, Math.max(0, video.volume + delta));
}

function ajustarTiempo(video, delta) {
	video.currentTime = Math.max(0, video.currentTime + delta);
}

function pantallaCompleta(video) {
	if (video.requestFullscreen) video.requestFullscreen();
	else if (video.webkitRequestFullscreen) video.webkitRequestFullscreen();
	else if (video.msRequestFullscreen) video.msRequestFullscreen();
}

function toggleMute(video) {
	video.muted = !video.muted;
}
