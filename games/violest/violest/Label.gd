extends Label

func _ready():
	text = "x " + str(Game.magic_balls_count)

func _process(delta):
	text = "x " + str(Game.magic_balls_count)
	
