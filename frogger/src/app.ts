import {
  Button,
  collides,
  GameLoop,
  imageAssets,
  init,
  initKeys,
  initPointer,
  keyPressed,
  load,
  setImagePath,
  Sprite,
  Text,
} from "kontra";

let { canvas, context } = init();

setImagePath("images");
initKeys();
initPointer();

load("basic_level.png", "player.png", "enemy.png").then(() => {
  let background = Sprite({
    x: 0,
    y: 0,
    image: imageAssets["images/basic_level.png"],
  });

  let player = Sprite({
    x: 120,
    y: 220,
    image: imageAssets["images/player.png"],
  });

  let enemies = [
    Sprite({
      x: 40,
      y: 70,
      image: imageAssets["images/enemy.png"],
      dx: 2.5,
    }),
    Sprite({
      x: 80,
      y: 110,
      image: imageAssets["images/enemy.png"],
      dx: 1,
    }),
    Sprite({
      x: 20,
      y: 140,
      image: imageAssets["images/enemy.png"],
      dx: 1.4,
    }),
    Sprite({
      x: 130,
      y: 170,
      image: imageAssets["images/enemy.png"],
      dx: 1.8,
    }),
  ];

  let result = Text({
    text: "You Won!",
    font: "24px Arial",
    color: "white",
    x: 120,
    y: 100,
    anchor: { x: 0.5, y: 0.5 },
    textAlign: "center",
  });

  let button = Button({
    x: 120,
    y: 120,
    anchor: { x: 0.5, y: 0.5 },

    // text properties
    text: {
      text: "New Game",
      color: "blue",
      font: "bold 12px Arial, sans-serif",
      anchor: { x: 0.5, y: 0.5 },
      background: "black",
    },
    onDown() {
      window.location.href = "/";
      this.y += 5;
    },
  });

  let loop = GameLoop({
    update: () => {
      if (keyPressed("arrowup")) {
        player.y -= 1;
      }
      if (keyPressed("arrowdown")) {
        player.y += 1;
      }
      player.update();

      enemies.forEach((enemy) => {
        if (enemy.x + enemy.width > canvas.width || enemy.x < 0) {
          enemy.dx = -enemy.dx;
        }

        enemy.update();
      });
    },
    render: () => {
      background.render();
      player.render();
      enemies.forEach((enemy) => {
        enemy.render();
      });

      if (player.y <= 30) {
        loop.stop();
        result.render();
        button.render();
      }

      enemies.forEach((enemy) => {
        if (collides(enemy, player)) {
          loop.stop();
          result.text = "You Lost!";
          result.render();
          button.render();
        }
      });
    },
  });

  loop.start();
});
