extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		_on_play_pressed()


func _on_play_pressed():
	Game.load_game()	


func _on_controls_pressed():
	Game.load_controls_screen()


func _on_credits_pressed():
	Game.load_credits_screen()	


func _on_back_pressed():
	Game.load_main_menu()
