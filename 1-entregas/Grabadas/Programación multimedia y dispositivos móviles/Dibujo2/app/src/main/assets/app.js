const canvas = document.getElementById("paintCanvas");
const ctx = canvas.getContext("2d");
const colorPicker = document.getElementById("colorPicker");
const brushSize = document.getElementById("brushSize");
const clearCanvas = document.getElementById("clearCanvas");
const brushShapeSelector = document.getElementById("brushShape");
const undoButton = document.getElementById("undo");
const redoButton = document.getElementById("redo");

canvas.width = window.innerWidth * 0.8;
canvas.height = window.innerHeight * 0.7;

let painting = false;
let brushColor = "#000000";
let brushWidth = 5;
let brushShape = "round";  // Forma predeterminada es redonda

let undoStack = [];
let redoStack = [];

function startPosition(e) {
    painting = true;
    draw(e);
}

function endPosition() {
    painting = false;
    ctx.beginPath();
    saveState();  // Guardamos el estado después de cada trazo
}

function draw(e) {
    if (!painting) return;
    e.preventDefault();
    let x, y;
    if (e.touches) {
        x = e.touches[0].clientX - canvas.offsetLeft;
        y = e.touches[0].clientY - canvas.offsetTop;
    } else {
        x = e.clientX - canvas.offsetLeft;
        y = e.clientY - canvas.offsetTop;
    }
    ctx.lineWidth = brushWidth;
    ctx.lineCap = "round";
    ctx.strokeStyle = brushColor;

    if (brushShape === "round") {
        // Pincel redondo
        ctx.lineTo(x, y);
        ctx.stroke();
    } else if (brushShape === "square") {
        // Pincel cuadrado
        ctx.beginPath();
        ctx.rect(x - brushWidth / 2, y - brushWidth / 2, brushWidth, brushWidth);
        ctx.fillStyle = brushColor;
        ctx.fill();
        ctx.beginPath();
    } else if (brushShape === "star") {
        // Pincel de estrella (simple)
        ctx.save();
        ctx.translate(x, y);
        ctx.beginPath();
        ctx.moveTo(0, -brushWidth);
        for (let i = 0; i < 5; i++) {
            ctx.rotate(Math.PI / 5);
            ctx.lineTo(0, -brushWidth / 2);
            ctx.rotate(Math.PI / 5);
            ctx.lineTo(0, -brushWidth);
        }
        ctx.closePath();
        ctx.fillStyle = brushColor;
        ctx.fill();
        ctx.restore();
    }

    ctx.beginPath();
    ctx.moveTo(x, y);
}

// Guardar el estado actual del canvas
function saveState() {
    const imageData = canvas.toDataURL();
    undoStack.push(imageData);
    redoStack = []; // Limpiar redoStack al hacer una nueva acción
}

// Deshacer la última acción
function undo() {
    if (undoStack.length > 1) {
        redoStack.push(undoStack.pop());
        const lastState = undoStack[undoStack.length - 1];
        const img = new Image();
        img.src = lastState;
        img.onload = function () {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.drawImage(img, 0, 0);
        };
    }
}

// Rehacer la última acción deshecha
function redo() {
    if (redoStack.length > 0) {
        const lastRedoState = redoStack.pop();
        undoStack.push(lastRedoState);
        const img = new Image();
        img.src = lastRedoState;
        img.onload = function () {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.drawImage(img, 0, 0);
        };
    }
}

canvas.addEventListener("mousedown", startPosition);
canvas.addEventListener("mouseup", endPosition);
canvas.addEventListener("mousemove", draw);

canvas.addEventListener("touchstart", startPosition);
canvas.addEventListener("touchend", endPosition);
canvas.addEventListener("touchmove", draw);

colorPicker.addEventListener("input", (e) => {
    brushColor = e.target.value;
});

brushSize.addEventListener("input", (e) => {
    brushWidth = e.target.value;
});

// Actualizar la forma del pincel según la selección del usuario
brushShapeSelector.addEventListener("change", (e) => {
    brushShape = e.target.value;
});

clearCanvas.addEventListener("click", () => {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    saveState();  // Guardar el estado después de borrar
});

// Asignar las funciones de deshacer y rehacer a los botones
undoButton.addEventListener("click", undo);
redoButton.addEventListener("click", redo);

// Guardar el estado inicial del canvas
saveState();