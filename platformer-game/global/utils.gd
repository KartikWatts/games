extends Node

const SAVE_PATH = "res://savegame.bin"

func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"playerHP": Game.playerHP,
		"gem": Game.gem,		
	}

	var jsonString = JSON.stringify(data)
	file.store_line(jsonString)
	
func load_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH) == true:
		if not file.eof_reached():
			var storedData = JSON.parse_string(file.get_line())
			if storedData:
				Game.playerHP = storedData["playerHP"]
				Game.gem = storedData["gem"]


