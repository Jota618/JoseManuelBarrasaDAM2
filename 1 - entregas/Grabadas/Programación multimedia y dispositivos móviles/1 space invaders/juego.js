const lienzo = document.getElementById("lienzoJuego"); // Obtiene el elemento canvas del documento
const ctx = lienzo.getContext("2d"); // Obtiene el contexto 2D para dibujar en el canvas

const imagenJugador = new Image(); // Crea una nueva imagen para el jugador
imagenJugador.src = "jugador.png"; // Establece la fuente de la imagen del jugador

const imagenEnemigo = new Image(); // Crea una nueva imagen para el enemigo
imagenEnemigo.src = "enemigo.png"; // Establece la fuente de la imagen del enemigo

const imagenBala = new Image(); // Crea una nueva imagen para la bala
imagenBala.src = "bala.png"; // Establece la fuente de la imagen de la bala

let jugador = {
    // Define las propiedades del jugador
    x: lienzo.width / 2 - 25, // Posición inicial en el eje x, centrado horizontalmente
    y: lienzo.height - 50, // Posición inicial en el eje y, cerca del borde inferior
    ancho: 50, // Ancho del jugador
    alto: 50, // Altura del jugador
    velocidad: 5, // Velocidad de movimiento del jugador
    dx: 0 // Cambio en la posición x, usado para movimiento
};

let balas = []; // Arreglo para almacenar las balas disparadas
let enemigos = []; // Arreglo para almacenar los enemigos
const tamanoEnemigo = 50; // Tamaño de los enemigos
let velocidadEnemigo = 0.5; // Velocidad de movimiento de los enemigos
let puntuacion = 0; // Puntaje del jugador
let vidas = 5; // Vidas del jugador
let nivel = 1; // Nivel actual del juego
let tasaAparicionEnemigo = 0.01; // Tasa de aparición de enemigos

function moverJugador() {
    jugador.x += jugador.dx; // Actualiza la posición x del jugador según su velocidad
    if (jugador.x < 0) jugador.x = 0; // Evita que el jugador salga por la izquierda
    if (jugador.x + jugador.ancho > lienzo.width) jugador.x = lienzo.width - jugador.ancho; // Evita que el jugador salga por la derecha
}

function dibujarJugador() {
    ctx.drawImage(imagenJugador, jugador.x, jugador.y, jugador.ancho, jugador.alto); // Dibuja al jugador en el canvas
}

function dibujarBalas() {
    balas.forEach((bala) => {
        // Itera sobre cada bala en el array
        ctx.drawImage(imagenBala, bala.x, bala.y, bala.ancho, bala.alto); // Dibuja cada bala en el canvas
    });
}

function dibujarEnemigos() {
    enemigos.forEach((enemigo) => {
        // Itera sobre cada enemigo en el array
        ctx.drawImage(imagenEnemigo, enemigo.x, enemigo.y, tamanoEnemigo, tamanoEnemigo); // Dibuja cada enemigo en el canvas
    });
}

function dibujarPuntuacion() {
    ctx.fillStyle = "white"; // Establece el color del texto
    ctx.font = "20px Arial"; // Establece la fuente del texto
    ctx.fillText("Puntuación: " + puntuacion, 10, 20); // Dibuja el puntaje en el canvas
}

function dibujarVidas() {
    ctx.fillStyle = "white"; // Establece el color del texto
    ctx.font = "20px Arial"; // Establece la fuente del texto
    ctx.fillText("Vidas: " + vidas, lienzo.width - 100, 20); // Dibuja las vidas restantes en el canvas
}

function dibujarNivel() {
    ctx.fillStyle = "white"; // Establece el color del texto
    ctx.font = "20px Arial"; // Establece la fuente del texto
    ctx.fillText("Nivel: " + nivel, lienzo.width / 2 - 30, 20); // Dibuja el nivel actual en el canvas
}

function actualizarBalas() {
    balas.forEach((bala, indice) => {
        // Itera sobre cada bala
        bala.y -= bala.velocidad; // Actualiza la posición y de cada bala
        if (bala.y < 0) {
            // Si la bala sale del canvas por arriba
            balas.splice(indice, 1); // Elimina la bala del array
        }
    });
}

function actualizarEnemigos() {
    enemigos.forEach((enemigo, indice) => {
        // Itera sobre cada enemigo
        enemigo.y += velocidadEnemigo; // Actualiza la posición y de cada enemigo
        if (enemigo.y > lienzo.height) {
            // Si el enemigo sale del canvas por abajo
            enemigos.splice(indice, 1); // Elimina el enemigo del array
            vidas--; // Reduce las vidas del jugador
            if (vidas <= 0) {
                // Si no quedan vidas
                alert("Juego terminado! Tu puntuación: " + puntuacion); // Muestra un mensaje de fin de juego
                document.location.reload(); // Recarga la página para reiniciar el juego
            }
        }
    });
}

function crearEnemigos() {
    if (Math.random() < tasaAparicionEnemigo) {
        // Decide si aparece un nuevo enemigo
        const x = Math.random() * (lienzo.width - tamanoEnemigo); // Posición x aleatoria dentro del canvas
        enemigos.push({ x: x, y: 0 }); // Agrega un nuevo enemigo al array
    }
}

function comprobarColisiones() {
    balas.forEach((bala, indiceBala) => {
        // Itera sobre cada bala
        enemigos.forEach((enemigo, indiceEnemigo) => {
            // Itera sobre cada enemigo
            // Verifica si hay colisión entre la bala y el enemigo
            if (
                bala.x < enemigo.x + tamanoEnemigo &&
                bala.x + bala.ancho > enemigo.x &&
                bala.y < enemigo.y + tamanoEnemigo &&
                bala.y + bala.alto > enemigo.y
            ) {
                enemigos.splice(indiceEnemigo, 1); // Elimina el enemigo del array
                balas.splice(indiceBala, 1); // Elimina la bala del array
                puntuacion += 10; // Aumenta el puntaje
                if (puntuacion % 100 === 0) {
                    // Cada 100 puntos
                    nivel++; // Aumenta el nivel
                    if (nivel % 2 === 0) {
                        // Cada segundo nivel
                        velocidadEnemigo += 0.25; // Aumenta la velocidad de los enemigos
                        tasaAparicionEnemigo += 0.005; // Aumenta la tasa de aparición de enemigos
                    }
                }
            }
        });
    });
}

// Maneja los eventos de teclado
document.addEventListener("keydown", (e) => {
    if (e.key === "ArrowLeft") {
        jugador.dx = -jugador.velocidad; // Mueve el jugador a la izquierda
    }
    if (e.key === "ArrowRight") {
        jugador.dx = jugador.velocidad; // Mueve el jugador a la derecha
    }
    if (e.key === " ") {
        // Si se presiona la barra espaciadora
        balas.push({
            // Agrega una nueva bala al array
            x: jugador.x + jugador.ancho / 2 - 5, // Posición x centrada en el jugador
            y: jugador.y, // Posición y en la del jugador
            ancho: 10, // Ancho de la bala
            alto: 20, // Alto de la bala
            velocidad: 5 // Velocidad de la bala
        });
    }
});

document.addEventListener("keyup", (e) => {
    if (e.key === "ArrowLeft" || e.key === "ArrowRight") {
        jugador.dx = 0; // Detiene el movimiento horizontal al soltar la tecla
    }
});

function actualizar() {
    ctx.clearRect(0, 0, lienzo.width, lienzo.height); // Limpia el canvas

    moverJugador(); // Actualiza la posición del jugador
    actualizarBalas(); // Actualiza la posición de las balas
    actualizarEnemigos(); // Actualiza la posición de los enemigos
    crearEnemigos(); // Crea nuevos enemigos
    comprobarColisiones(); // Verifica colisiones entre balas y enemigos

    dibujarJugador(); // Dibuja al jugador
    dibujarBalas(); // Dibuja las balas
    dibujarEnemigos(); // Dibuja los enemigos
    dibujarPuntuacion(); // Dibuja la puntuación
    dibujarVidas(); // Dibuja las vidas
    dibujarNivel(); // Dibuja el nivel

    requestAnimationFrame(actualizar); // Llama a la función de actualización en el siguiente frame
}

actualizar(); // Inicia el bucle de actualización
