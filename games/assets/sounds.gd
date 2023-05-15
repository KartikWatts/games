extends Node2D

@onready var main_bgm = $MainBgm
@onready var click_sound = $ClickSound

func _process(_delta):
	if not Game.has_game_sound:
		main_bgm.stop()
	else:
		if not main_bgm.playing and get_parent().name == "World":
			main_bgm.play()
					
func play_bgm():
	if Game.has_game_sound:
		main_bgm.play()

func play_click_sound():
	if Game.has_game_sound:
		click_sound.play()
		await click_sound.finished
