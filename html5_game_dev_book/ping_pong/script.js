(function ($) {
	// data definition

	var pingpong = {
		paddleA: {
			x: 50,

			y: 100,

			width: 30,

			height: 100,
		},

		paddleB: {
			x: 700,

			y: 100,

			width: 30,

			height: 100,
		},

		playground: {
			offsetTop: $("#playground").offset().top,

			height: parseInt($("#playground").height()),

			width: parseInt($("#playground").width()),
		},

		ball: {
			speed: 8,

			x: 150,

			y: 100,

			directionX: 1,

			directionY: 1,
		},

		scoreA: 0, // score for player A

		scoreB: 0, // score for player B
	};

	// view rendering

	function renderPaddles() {
		$("#paddleB").css("top", pingpong.paddleB.y);

		$("#paddleA").css("top", pingpong.paddleA.y);
	}

	function handleMouseInputs() {
		// run the game when mouse moves in the playground.

		$("#playground").mouseenter(function () {
			pingpong.isPaused = false;
		});

		$("#playground").mouseleave(function () {
			pingpong.isPaused = true;
		});

		// calculate the paddle position by using the mouse position.

		$("#playground").mousemove(function (e) {
			pingpong.paddleB.y = e.pageY - pingpong.playground.offsetTop;
		});
	}

	function autoMovePaddleA() {
		var speed = 3;

		var direction = 1;

		var paddleY = pingpong.paddleA.y + pingpong.paddleA.height / 2;

		if (paddleY > pingpong.ball.y) {
			direction = -1;
		}

		pingpong.paddleA.y += speed * direction;
	}

	function gameloop() {
		moveBall();
	}

	function ballHitsTopBottom() {
		var y =
			pingpong.ball.y + pingpong.ball.speed * pingpong.ball.directionY;

		return y < 0 || y > pingpong.playground.height;
	}

	function ballHitsRightWall() {
		return (
			pingpong.ball.x + pingpong.ball.speed * pingpong.ball.directionX >
			pingpong.playground.width
		);
	}

	function ballHitsLeftWall() {
		return (
			pingpong.ball.x + pingpong.ball.speed * pingpong.ball.directionX < 0
		);
	}

	function playerAWin() {
		// reset the ball;

		pingpong.ball.x = 250;

		pingpong.ball.y = 100;

		// update the ball location variables;

		pingpong.ball.directionX = -1;
		pingpong.scoreA += 1;
		$("#score-a").text(pingpong.scoreA);
	}

	function playerBWin() {
		// reset the ball;

		pingpong.ball.x = 150;

		pingpong.ball.y = 100;

		pingpong.ball.directionX = 1;
		pingpong.scoreB += 1;
		$("#score-b").text(pingpong.scoreB);
	}

	function moveBall() {
		// reference useful varaibles

		var ball = pingpong.ball;

		// check playground top/bottom boundary

		if (ballHitsTopBottom()) {
			// reverse direction

			ball.directionY *= -1;
		}

		// check right

		if (ballHitsRightWall()) {
			playerAWin();
		}

		// check left

		if (ballHitsLeftWall()) {
			playerBWin();
		}

		// check paddles here

		// Variables for checking paddles

		var ballX = ball.x + ball.speed * ball.directionX;

		var ballY = ball.y + ball.speed * ball.directionY;

		// check moving paddle here, later.

		// check left paddle

		if (
			ballX >= pingpong.paddleA.x &&
			ballX < pingpong.paddleA.x + pingpong.paddleA.width
		) {
			if (
				ballY <= pingpong.paddleA.y + pingpong.paddleA.height &&
				ballY >= pingpong.paddleA.y
			) {
				ball.directionX = 1;
			}
		}

		// check right paddle

		if (
			ballX >= pingpong.paddleB.x &&
			ballX < pingpong.paddleB.x + pingpong.paddleB.width
		) {
			if (
				ballY <= pingpong.paddleB.y + pingpong.paddleB.height &&
				ballY >= pingpong.paddleB.y
			) {
				ball.directionX = -1;
			}
		}

		// update the ball position data

		ball.x += ball.speed * ball.directionX;

		ball.y += ball.speed * ball.directionY;
	}

	function init() {
		// view rendering
		pingpong.timer = setInterval(gameloop, 1000 / 30);

		window.requestAnimationFrame(render);

		// inputs

		handleMouseInputs();
	}

	(function ($) {
		// All our existing code

		// Execute the starting point

		init();
	})(jQuery);

	function renderBall() {
		var ball = pingpong.ball;

		$("#ball").css({
			left: ball.x + ball.speed * ball.directionX,

			top: ball.y + ball.speed * ball.directionY,
		});
	}

	function render() {
		renderBall();
		renderPaddles();
		autoMovePaddleA();

		window.requestAnimationFrame(render);
	}

	renderPaddles();
})(jQuery);
