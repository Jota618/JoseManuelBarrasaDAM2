onmessage = function () {
    // El worker escucha
    console.log("Empezamos"); // Hace algo
    postMessage("Soy el worker y funciono"); // Devuelve un mensaje al hilo principal
};
