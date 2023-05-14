extends Label

func _ready():
	text = "Hostility: " + str(Game.game_difficulty)

func _process(delta):
	text = "Hostility: " + str(Game.game_difficulty)
	
