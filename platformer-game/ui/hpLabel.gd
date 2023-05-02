extends RichTextLabel

var heartImage = load("res://assets/environment/props/heart.png")

func _ready():
	for i in range(0, Game.playerHP):
		add_image(heartImage, 25, 25)

func _process(delta):
	clear()
	for i in range(0, Game.playerHP):
		add_image(heartImage, 25, 25)
