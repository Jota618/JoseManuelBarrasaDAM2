const canvas = document.getElementById('gameCanvas');
const ctx = canvas.getContext('2d');

const playerImg = new Image();
playerImg.src = 'player.png'; // Asegúrate de tener esta imagen

const enemyImg = new Image();
enemyImg.src = 'enemy.png'; // Asegúrate de tener esta imagen

const bulletImg = new Image();
bulletImg.src = 'bullet.png'; // Asegúrate de tener esta imagen

let player = {
    x: canvas.width / 2 - 25,
    y: canvas.height - 50,
    width: 50,
    height: 50,
    speed: 5,
    dx: 0
};

let bullets = [];
let enemies = [];
const enemySize = 50;
let enemySpeed = 0.5;
let score = 0;
let lives = 3;
let level = 1;
let enemySpawnRate = 0.01;

function movePlayer() {
    player.x += player.dx;
    if (player.x < 0) player.x = 0;
    if (player.x + player.width > canvas.width) player.x = canvas.width - player.width;
}

function drawPlayer() {
    ctx.drawImage(playerImg, player.x, player.y, player.width, player.height);
}

function drawBullets() {
    bullets.forEach(bullet => {
        ctx.drawImage(bulletImg, bullet.x, bullet.y, bullet.width, bullet.height);
    });
}

function drawEnemies() {
    enemies.forEach(enemy => {
        ctx.drawImage(enemyImg, enemy.x, enemy.y, enemySize, enemySize);
    });
}

function drawScore() {
    ctx.fillStyle = 'white';
    ctx.font = '20px Arial';
    ctx.fillText('Score: ' + score, 10, 20);
}

function drawLives() {
    ctx.fillStyle = 'white';
    ctx.font = '20px Arial';
    ctx.fillText('Lives: ' + lives, canvas.width - 100, 20);
}

function drawLevel() {
    ctx.fillStyle = 'white';
    ctx.font = '20px Arial';
    ctx.fillText('Level: ' + level, canvas.width / 2 - 30, 20);
}

function updateBullets() {
    bullets.forEach((bullet, index) => {
        bullet.y -= bullet.speed;
        if (bullet.y < 0) {
            bullets.splice(index, 1);
        }
    });
}

function updateEnemies() {
    enemies.forEach((enemy, index) => {
        enemy.y += enemySpeed;
        if (enemy.y > canvas.height) {
            enemies.splice(index, 1);
            lives--;
            if (lives <= 0) {
                alert('Game Over! Your score: ' + score);
                document.location.reload();
            }
        }
    });
}

function createEnemies() {
    if (Math.random() < enemySpawnRate) {
        const x = Math.random() * (canvas.width - enemySize);
        enemies.push({ x: x, y: 0 });
    }
}

function checkCollisions() {
    bullets.forEach((bullet, bulletIndex) => {
        enemies.forEach((enemy, enemyIndex) => {
            if (
                bullet.x < enemy.x + enemySize &&
                bullet.x + bullet.width > enemy.x &&
                bullet.y < enemy.y + enemySize &&
                bullet.y + bullet.height > enemy.y
            ) {
                enemies.splice(enemyIndex, 1);
                bullets.splice(bulletIndex, 1);
                score += 10;
                if (score % 100 === 0) {
                    level++;
                    if (level % 2 === 0) {
                        enemySpeed += 0.25;
                        enemySpawnRate += 0.005;
                    }
                }
            }
        });
    });
}

document.addEventListener('keydown', (e) => {
    if (e.key === 'ArrowLeft') {
        player.dx = -player.speed;
    }
    if (e.key === 'ArrowRight') {
        player.dx = player.speed;
    }
    if (e.key === ' ') {
        bullets.push({
            x: player.x + player.width / 2 - 5,
 y: player.y,
            width: 10,
            height: 20,
            speed: 5
        });
    }
});

document.addEventListener('keyup', (e) => {
    if (e.key === 'ArrowLeft' || e.key === 'ArrowRight') {
        player.dx = 0;
    }
});

function update() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    movePlayer();
    updateBullets();
    updateEnemies();
    createEnemies();
    checkCollisions();

    drawPlayer();
    drawBullets();
    drawEnemies();
    drawScore();
    drawLives();
    drawLevel();

    requestAnimationFrame(update);
}

update();