onmessage = function(){                                 // El worker escucha
    console.log("Funciono");                             // Hace algo
    postMessage("Hola soy el worker y vuelvo al proceso principal")       // Devuelve un mensaje al hilo principal
}
