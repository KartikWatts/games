extends Node2D

@onready var _player = $"../Player"
@onready var _info_panel = $"../UILabel/InfoPanel"
@onready var _info_message = $"../UILabel/InfoMessage"

@onready var _instruction_1 = $Instruction1
@onready var _check_1 = $Checkpoint1
@onready var _finish= $Finish

var _is_getting_instructed = false
var instruction_number = -1
var instructions = ["Hii traveller, Welcome to this journey to enlightenment!", "Use Arrow Keys or W/A/S/D to move. Spacebar key to Jump", "Press Shift or H key to launch the powerful Gola from your Dand. It would take some to build. Let it build...", "While the Gola is building, you can Press Shift or H to cancel the build. You have limited amount, use judiciously. Collect more during the journey.", "Gola will protect you from creatures during the journey. However the creatures are only doing self protection", "You can jump over the snake, and you won't get hurt until you contact the forward part of his body", "The less violence and less time you take, easier will be the journey, hostility increases with more time and kills you do.", "Karma's watchful eye, Less yields more, let's simplify.", ""]

func _physics_process(delta):
	if not _info_message.get_total_character_count():
		_info_panel.hide()
	else:
		_info_panel.show()
				
	if _is_getting_instructed:
		if Input.is_action_just_pressed("player_continue"):
			instruction_number += 1
		if Input.is_action_just_pressed("player_skip"):
			instruction_number = instructions.size()-1
		if _player.global_position.x > 2000:
			instruction_number = instructions.size()-1	
			
		var extra_text = ""
		if instruction_number != instructions.size()-1:
			extra_text = "\n Press K to continue    Press J to Skip"
		if instruction_number < instructions.size()-1:
			_info_message.text = instructions[instruction_number] + extra_text
		else:
			_info_message.text = ""
			_is_getting_instructed = false
			
	
func _on_instruction_1_screen_entered():
	_info_message.text = ""
	await get_tree().create_timer(0.5).timeout
	instruction_number = 0
	_is_getting_instructed = true
	_instruction_1.queue_free()


func _on_checkpoint_1_screen_entered():
	Game.player_spawn_position = _check_1.global_position
	_info_message.text = "Checkpoint 1 Reached!!\n The Lowland world starts from here"
	_check_1.queue_free()
	await get_tree().create_timer(4).timeout
	_info_message.text = ""
	


func _on_finish_screen_entered():
	_info_message.text = "Game Finished!!\n COULDN'T COMPLETE LEVEL DESIGN PROPERLY.. SORRY GUYS. \n You are awesome! Thanks."
	await get_tree().create_timer(6).timeout
	Game.load_main_menu()
