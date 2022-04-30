const gameBtn = document.querySelector("#game_btn");
const power1Span = document.querySelector("#p1_power");
const power2Span = document.querySelector("#p2_power");

const canvas = document.getElementById("canvas");
const ctx = canvas.getContext("2d");
let image = new Image();
image.src = "char.png";

ctx.canvas.width = 900;
ctx.canvas.height = 500;

let x = 450,
  y = 350;

let x2 = 380,
  y2 = 350;

let botX = 520,
  botY = 350;

let p1PowerUp = 2,
  p2PowerUp = 2,
  p1BoosterInuse = false,
  p2BoosterInuse = false;

let isGameOver = false,
  isGameOverP1 = false,
  isGameOverP2 = false,
  isBotWins = false,
  isPlayerWin = false;

let p1Speed = 2,
  p2Speed = 2;
let botSpeed = 2.6;
let canBotMove = false;

let obstaclesArray = [];

let startGame = false;
gameBtn.addEventListener("click", () => {
  canBotMove = false;
  obstaclesArray = [
    { obsYPos: 30, obsXPos: 800 * Math.random(), obsWidth: 80, obsHeight: 4 },
    { obsYPos: 120, obsXPos: 800 * Math.random(), obsWidth: 80, obsHeight: 4 },
    { obsYPos: 220, obsXPos: 800 * Math.random(), obsWidth: 80, obsHeight: 4 },
  ];

  let countDown = 3;
  gameBtn.style.cursor = "none";
  gameBtn.style.pointerEvents = "none";

  (x = 450), (y = 350), (x2 = 380), (y2 = 350), (botX = 520), (botY = 350);
  (p1PowerUp = 2),
    (p2PowerUp = 2),
    (p1BoosterInuse = false),
    (p2BoosterInuse = false);
  power1Span.innerHTML = p1PowerUp;
  power2Span.innerHTML = p2PowerUp;

  setInterval(() => {
    if (countDown > 0) {
      gameBtn.innerHTML = `Starts in ${countDown}...`;
      countDown--;
    }
  }, 800);

  setTimeout(() => {
    startGame = true;
    gameBtn.style.opacity = "0";
    (isGameOver = false),
      (isGameOverP1 = false),
      (isGameOverP2 = false),
      (isBotWins = false),
      (isPlayerWin = false);
  }, 3000);
  setTimeout(() => {
    canBotMove = true;
  }, 3500);
});

let keysPressed = [];

setInterval(() => {
  if (!startGame || isGameOver) return;
  keysPressed.map((key) => {
    if (!isGameOver) {
      if (!isGameOverP1) {
        if (key === "ArrowUp") y -= p1Speed;
        if (key === "ArrowDown") y += p1Speed;
        if (key === "ArrowLeft") x -= p1Speed;
        if (key === "ArrowRight") x += p1Speed;
      }
      if (!isGameOverP2) {
        if (key === "w") y2 -= p2Speed;
        if (key === "s") y2 += p2Speed;
        if (key === "a") x2 -= p2Speed;
        if (key === "d") x2 += p2Speed;
      }
    }
  });

  if (botY <= 10) {
    isBotWins = true;
  }
  if (y <= 10 || y2 <= 10) {
    isPlayerWin = true;
  }
  if (isBotWins || isPlayerWin) {
    isGameOver = true;

    ctx.fillStyle = "white";
    ctx.fillRect(250, 185, 400, 100);
    ctx.fillStyle = "black";
    ctx.font = "35px Roboto";
    if (isBotWins) {
      ctx.fillText("Bot Wins", 350, 250);
    }
    if (isPlayerWin) {
      ctx.fillText(`${y <= 10 ? "Player 1" : "Player 2"} Wins`, 350, 250);
    }
  }
  if (isGameOver) {
    gameBtn.innerHTML = "Restart";
    gameBtn.style.opacity = "1";
    gameBtn.style.cursor = "pointer";
    gameBtn.style.pointerEvents = "all";
    canBotMove = false;
    return;
  }
  ctx.clearRect(0, 0, 900, 500);
  drawObstacle();
  moveBot();
  draw(x, y);
  draw(x2, y2, true);
  if (p2Speed == 3) {
    drawBoost(x2, y2);
  }
  if (p1Speed == 3) {
    drawBoost(x, y);
  }
}, 20);

drawObstacle();
bot();
draw(x, y);
draw(x2, y2, true);

function bot() {
  ctx.fillStyle = "red";
  ctx.fillRect(botX, botY, 30, 50);
}

function moveBot() {
  collisionDetect(botX, botY - 4, "bot");
  bot();
}

function drawObstacle() {
  obstaclesArray.map((obs) => {
    ctx.fillStyle = "yellow";
    ctx.fillRect(1, obs.obsYPos, 900, obs.obsHeight);
    ctx.fillStyle = "green";
    ctx.fillRect(obs.obsXPos, obs.obsYPos, 80, obs.obsHeight);
  });
}

document.addEventListener("keydown", (e) => {
  if (e.key === "0") {
    if (p1PowerUp > 0 && !p1BoosterInuse && !isGameOverP1) {
      p1Speed = 3;
      p1BoosterInuse = true;
      setTimeout(() => {
        p1Speed = 2;
        p1BoosterInuse = false;
      }, 1500);
      p1PowerUp--;
      power1Span.innerHTML = p1PowerUp;
    }
  }
  if (e.key === "g") {
    if (p2PowerUp > 0 && !p2BoosterInuse && !isGameOverP2) {
      p2BoosterInuse = true;
      p2Speed = 3;
      setTimeout(() => {
        p2Speed = 2;
        p2BoosterInuse = false;
      }, 1500);
      p2PowerUp--;
      power2Span.innerHTML = p2PowerUp;
    }
  }
  if (!keysPressed.find((key) => key === e.key)) {
    keysPressed.push(e.key);
  }
});

document.addEventListener("keyup", (e) => {
  let index = keysPressed.indexOf(e.key);
  keysPressed.splice(index, 1);
});

function collisionDetect(tx, ty, player) {
  let isCollisionBot = false;
  let isXHigher = true;

  for (let i = 0; i < obstaclesArray.length; i++) {
    obs = obstaclesArray[i];
    if (
      (tx + 30 > obs.obsXPos + obs.obsWidth || tx < obs.obsXPos) &&
      ty + 50 > obs.obsYPos &&
      ty < obs.obsYPos + obs.obsHeight
    ) {
      if (player != "bot") {
        if (player == "player1") isGameOverP1 = true;
        if (player == "player2") isGameOverP2 = true;
        ctx.fillStyle = `${player == "player1" ? "blue" : "purple"}`;
        ctx.font = "20px Roboto";
        ctx.fillText(
          `Game Over ${player == "player1" ? "Player 1" : "Player 2"}`,
          tx + 30,
          ty + 20
        );
      } else {
        if (tx > obs.obsXPos) {
          isXHigher = false;
        }
        isCollisionBot = true;
      }
    }
  }
  if (player == "bot" && canBotMove) {
    if (isCollisionBot) {
      if (isXHigher) botX += botSpeed;
      else botX -= botSpeed;
    } else {
      botY -= botSpeed;
    }
  }
}

function draw(lx, ly, player2 = false) {
  ctx.fillStyle = "blue";
  if (player2) ctx.fillStyle = "purple";
  ctx.fillRect(lx, ly, 30, 50);
  ctx.drawImage(image, lx - 10, ly, 50, 50);
  if (player2) collisionDetect(lx, ly, "player2");
  else collisionDetect(lx, ly, "player1");
}

function drawBoost(lx, ly) {
  ctx.fillStyle = "orange";
  ctx.beginPath();
  lx = lx + 5;
  ly = ly + 50;
  ctx.moveTo(lx, ly);
  ctx.lineTo(lx + 20, ly);
  ctx.lineTo(lx + 10, ly + 20);
  ctx.lineTo(lx, ly);
  ctx.fill();
  ctx.fillStyle = "red";
  ctx.lineWidth = 3;
  ctx.stroke();
  ctx.closePath();
}
