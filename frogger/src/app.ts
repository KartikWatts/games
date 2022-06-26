import {
  GameLoop,
  imageAssets,
  init,
  load,
  setImagePath,
  Sprite,
} from "kontra";

let { canvas, context } = init();

let gameCanvas = document.getElementById("game"),
  canvasWidth: number,
  canvasHeight: number;

if (gameCanvas) {
  canvasWidth = gameCanvas.offsetWidth;
  canvasHeight = gameCanvas.offsetHeight;
}

setImagePath("images");

load("basic_level.png", "player.png", "enemy.png").then(() => {
  let backgroundImage = new Image();
  backgroundImage.src = "images/basic_level.png";
  let background = Sprite({
    x: 0,
    y: 0,
    image: backgroundImage,
  });

  let loop = GameLoop({
    update: () => {
      background.update();
    },
    render: () => {
      background.render();
    },
  });

  loop.start();
});
