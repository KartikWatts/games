if (untangleGame === undefined) {
	var untangleGame = {};
}

untangleGame.thinLineThickness = 1;
untangleGame.boldLineThickness = 5;
untangleGame.lines = [];
untangleGame.circles = [];

untangleGame.Circle = function (x, y, radius) {
	this.x = x;

	this.y = y;

	this.radius = radius;
};

untangleGame.Line = function (startPoint, endPoint, thickness) {
	this.startPoint = startPoint;

	this.endPoint = endPoint;

	this.thickness = thickness;
};

untangleGame.drawCircle = function (x, y, radius) {
	var ctx = untangleGame.ctx;

	ctx.fillStyle = "GOLD";

	ctx.beginPath();

	ctx.arc(x, y, radius, 0, Math.PI * 2, true);

	ctx.closePath();

	ctx.fill();
};

untangleGame.drawLine = function (x1, y1, x2, y2, thickness) {
	var ctx = untangleGame.ctx;

	ctx.beginPath();

	ctx.moveTo(x1, y1);

	ctx.lineTo(x2, y2);

	ctx.lineWidth = thickness;

	ctx.strokeStyle = "#cfc";

	ctx.stroke();
};

untangleGame.createRandomCircles = function (width, height) {
	// randomly draw 5 circles

	var circlesCount = 5;

	var circleRadius = 10;

	for (var i = 0; i < circlesCount; i++) {
		var x = Math.random() * width;

		var y = Math.random() * height;

		untangleGame.drawCircle(x, y, circleRadius);
		untangleGame.circles.push(new untangleGame.Circle(x, y, circleRadius));
	}
};

untangleGame.connectCircles = function () {
	// connect the circles to each other with lines

	untangleGame.lines.length = 0;

	for (var i = 0; i < untangleGame.circles.length; i++) {
		var startPoint = untangleGame.circles[i];

		for (var j = 0; j < i; j++) {
			var endPoint = untangleGame.circles[j];

			untangleGame.drawLine(
				startPoint.x,
				startPoint.y,

				endPoint.x,

				endPoint.y,
				1
			);

			untangleGame.lines.push(
				new untangleGame.Line(
					startPoint,

					endPoint,

					untangleGame.thinLineThickness
				)
			);
		}
	}
};

untangleGame.clear = function () {
	var ctx = untangleGame.ctx;

	ctx.clearRect(0, 0, ctx.canvas.width, ctx.canvas.height);
};

untangleGame.drawAllLines = function () {
	// draw all remembered lines

	for (var i = 0; i < untangleGame.lines.length; i++) {
		var line = untangleGame.lines[i];

		var startPoint = line.startPoint;

		var endPoint = line.endPoint;

		var thickness = line.thickness;

		untangleGame.drawLine(
			startPoint.x,
			startPoint.y,

			endPoint.x,

			endPoint.y,
			thickness
		);
	}
};

untangleGame.drawAllCircles = function () {
	// draw all remembered circles

	for (var i = 0; i < untangleGame.circles.length; i++) {
		var circle = untangleGame.circles[i];

		untangleGame.drawCircle(circle.x, circle.y, circle.radius);
	}
};

function gameloop() {
	// clear the Canvas before re-drawing.

	untangleGame.clear();

	untangleGame.drawAllLines();

	untangleGame.drawAllCircles();
	untangleGame.updateLineIntersection();
}

untangleGame.handleInput = function () {
	// Add Mouse Event Listener to canvas

	// we find if the mouse down position is on any circle

	// and set that circle as target dragging circle.

	$("#game").bind("mousedown touchstart", function (e) {
		e.preventDefault();

		// touch or mouse position

		var touch = e.originalEvent.touches && e.originalEvent.touches[0];

		var pageX = (touch || e).pageX;

		var pageY = (touch || e).pageY;

		var canvasPosition = $(this).offset();

		var mouseX = pageX - canvasPosition.left;

		var mouseY = pageY - canvasPosition.top;

		for (var i = 0; i < untangleGame.circles.length; i++) {
			var circleX = untangleGame.circles[i].x;

			var circleY = untangleGame.circles[i].y;

			var radius = untangleGame.circles[i].radius;

			if (
				Math.pow(mouseX - circleX, 2) + Math.pow(mouseY - circleY, 2) <
				Math.pow(radius, 2)
			) {
				untangleGame.targetCircleIndex = i;

				break;
			}
		}
	});

	// we move the target dragging circle

	// when the mouse is moving

	$("#game").bind("mousemove touchmove", function (e) {
		if (untangleGame.targetCircleIndex !== undefined) {
			e.preventDefault();

			// touch or mouse position

			var touch = e.originalEvent.touches && e.originalEvent.touches[0];

			var pageX = (touch || e).pageX;

			var pageY = (touch || e).pageY;

			var canvasPosition = $(this).offset();

			var mouseX = pageX - canvasPosition.left;

			var mouseY = pageY - canvasPosition.top;

			var circle = untangleGame.circles[untangleGame.targetCircleIndex];

			circle.x = mouseX;

			circle.y = mouseY;
		}

		untangleGame.connectCircles();
	});

	// We clear the dragging circle data when mouse is up

	$("#game").bind("mouseup touchend", function (e) {
		untangleGame.targetCircleIndex = undefined;
	});
};

untangleGame.isIntersect = function (line1, line2) {
	// convert line1 to general form of line: Ax+By = C

	var a1 = line1.endPoint.y - line1.startPoint.y;

	var b1 = line1.startPoint.x - line1.endPoint.x;

	var c1 = a1 * line1.startPoint.x + b1 * line1.startPoint.y;

	// convert line2 to general form of line: Ax+By = C

	var a2 = line2.endPoint.y - line2.startPoint.y;

	var b2 = line2.startPoint.x - line2.endPoint.x;

	var c2 = a2 * line2.startPoint.x + b2 * line2.startPoint.y;

	// calculate the intersection point

	var d = a1 * b2 - a2 * b1;

	// parallel when d is 0

	if (d === 0) {
		return false;
	}

	// solve the interception point at (x, y)

	var x = (b2 * c1 - b1 * c2) / d;

	var y = (a1 * c2 - a2 * c1) / d;

	// check if the interception point is on both line segments

	if (
		(untangleGame.isInBetween(line1.startPoint.x, x, line1.endPoint.x) ||
			untangleGame.isInBetween(
				line1.startPoint.y,
				y,
				line1.endPoint.y
			)) &&
		(untangleGame.isInBetween(line2.startPoint.x, x, line2.endPoint.x) ||
			untangleGame.isInBetween(line2.startPoint.y, y, line2.endPoint.y))
	) {
		return true;
	}

	// by default the given lines is not intersected.

	return false;
};

// return true if b is between a and c,

// we exclude the result when a==b or b==c

untangleGame.isInBetween = function (a, b, c) {
	// return false if b is almost equal to a or c.

	// this is to eliminate some floating point when

	// two value is equal to each other

	// but different with 0.00000...0001

	if (Math.abs(a - b) < 0.000001 || Math.abs(b - c) < 0.000001) {
		return false;
	}

	// true when b is in between a and c

	return (a < b && b < c) || (c < b && b < a);
};

untangleGame.updateLineIntersection = function () {
	// checking lines intersection and bold those lines.

	for (var i = 0; i < untangleGame.lines.length; i++) {
		for (var j = 0; j < i; j++) {
			var line1 = untangleGame.lines[i];

			var line2 = untangleGame.lines[j];

			// we check if two lines are intersected,

			// and bold the line if they are.

			if (untangleGame.isIntersect(line1, line2)) {
				line1.thickness = untangleGame.boldLineThickness;

				line2.thickness = untangleGame.boldLineThickness;
			}
		}
	}
};

$(document).ready(function () {
	var canvas = document.getElementById("game");

	untangleGame.ctx = canvas.getContext("2d");

	var width = canvas.width;

	var height = canvas.height;

	untangleGame.createRandomCircles(width, height);
	untangleGame.connectCircles();
	untangleGame.handleInput();
	untangleGame.updateLineIntersection();
	setInterval(gameloop, 30);
});
