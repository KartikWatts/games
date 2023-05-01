extends Node2D

func _on_load_game_pressed():
	Utils.load_game()
	get_tree().change_scene_to_file("res://world.tscn")

func _on_new_game_pressed():
	Game.playerHP = Game.INIT_PLAYER_HP
	Game.gem = Game.INIT_GEM
	get_tree().change_scene_to_file("res://world.tscn")
	
func _on_quit_pressed():
	get_tree().quit()
