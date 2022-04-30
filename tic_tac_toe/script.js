const game = () => {
  let board = document.querySelector(".board");

  let game_completed = false;

  let cross = "<div data-value='x' class='sign cross_sign'></div>";
  let circle = "<div data-value='o' class='sign circle_sign'></div>";
  let sign_value = cross;

  let box_array = [];

  let win = [
    [0, 1, 2], // Check first row.
    [3, 4, 5], // Check second Row
    [6, 7, 8], // Check third Row
    [0, 3, 6], // Check first column
    [1, 4, 7], // Check second Column
    [2, 5, 8], // Check third Column
    [0, 4, 8], // Check first Diagonal
    [2, 4, 6], // Check second Diagonal
  ];

  for (let index = 0; index < 9; index++) {
    let box_content = { id: `box_${index}`, value: "" };
    box_array.push(box_content);
  }

  box_array.map((b) => {
    board.innerHTML += `<div class="box" id=${b.id}>${b.value}</div>`;
  });

  let box_div_list = document.querySelectorAll(".box");
  box_div_list = [...box_div_list];

  box_div_list.map((box) => {
    let curr_box_index = box_array.findIndex((b) => b.id == box.id);
    box.onmouseover = () => {
      if (box_array[curr_box_index].value == "" && !game_completed)
        box.style.background = "#b3ffb7";
    };
    box.onmouseout = () => {
      box.style.background = "white";
    };
    box.onclick = () => {
      if (box_array[curr_box_index].value == "" && !game_completed) {
        box.innerHTML = sign_value;
        let temp = document.createElement("div");
        temp.innerHTML = sign_value;
        box_array[curr_box_index].value =
          temp.firstChild.getAttribute("data-value");
        let sign;
        if (sign_value == cross) sign = "x";
        else sign = "o";

        let isWon = checkArrayForWin(sign);
        let isDrawn = checkArrayForDraw();

        if (isWon || isDrawn) {
          game_completed = true;
          newGameBtn.style.cursor = "pointer";
          newGameBtn.style.pointerEvents = "all";
          document.querySelector(".result").style.opacity = 1;
          if (isWon) {
            document.querySelector(
              ".result-text"
            ).innerHTML = `${sign.toUpperCase()} Won!`;
          } else if (isDrawn) {
            document.querySelector(".result-text").innerHTML = `Game Drawn!`;
          }
        }

        if (sign_value == cross) sign_value = circle;
        else sign_value = cross;
        box.style.cursor = "default";
      }
    };
  });

  const checkArrayForWin = (sign) => {
    for (let i = 0; i < 8; i++)
      if (
        box_array[win[i][0]].value == sign &&
        box_array[win[i][1]].value == sign &&
        box_array[win[i][2]].value == sign
      )
        return true;
    return false;
  };

  const checkArrayForDraw = () => {
    for (let i = 0; i < 9; i++) if (box_array[i].value == "") return false;
    return true;
  };
};

game();

let newGameBtn = document.querySelector(".new-game-button");
newGameBtn.style.cursor = "none";
newGameBtn.style.pointerEvents = "none";

newGameBtn.onclick = () => {
  let box_div_list = document.querySelectorAll(".box");
  box_div_list = [...box_div_list];
  box_div_list.map((box) => {
    box.remove();
  });
  newGameBtn.style.cursor = "none";
  newGameBtn.style.pointerEvents = "none";

  document.querySelector(".result").style.opacity = 0;
  game();
};
