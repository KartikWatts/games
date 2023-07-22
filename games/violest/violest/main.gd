extends Node2D

@onready var _sounds = $Sounds

func _ready():
	if self.has_node("Difficulty"):
		if Game.selected_difficulty_level == Game.SOFT_DIFFICULTY_LEVEL:
			$Difficulty.select(0)
		if Game.selected_difficulty_level == Game.BALANCED_DIFFICULTY_LEVEL:
			$Difficulty.select(1)
		if Game.selected_difficulty_level == Game.HARSH_DIFFICULTY_LEVEL:
			$Difficulty.select(2)
	
	if self.has_node("Sound"):
		if Game.has_game_sound:
			$Sound.select(0)
		else:
			$Sound.select(1)
			

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		_on_play_pressed()

func _on_play_pressed():
	await _sounds.play_click_sound()
	Game.load_game()	


func _on_controls_pressed():
	await _sounds.play_click_sound()
	Game.load_controls_screen()


func _on_credits_pressed():
	await _sounds.play_click_sound()
	Game.load_credits_screen()	


func _on_back_pressed():
	await _sounds.play_click_sound()
	Game.load_main_menu()


func _on_sound_item_selected(index):
	if index == 1:
		Game.has_game_sound = false
	elif index == 0:
		await _sounds.play_click_sound()
		Game.has_game_sound = true


func _on_difficulty_item_selected(index):
	await _sounds.play_click_sound()
	if index == 0:
		Game.selected_difficulty_level = Game.SOFT_DIFFICULTY_LEVEL
		Game.update_game_difficulty(Game.SOFT_DIFFICULTY_LEVEL)
	if index == 1:
		Game.selected_difficulty_level = Game.BALANCED_DIFFICULTY_LEVEL
		Game.update_game_difficulty(Game.BALANCED_DIFFICULTY_LEVEL)
	if index == 2:
		Game.selected_difficulty_level = Game.HARSH_DIFFICULTY_LEVEL
		Game.update_game_difficulty(Game.HARSH_DIFFICULTY_LEVEL)
