extends Node2D

@onready var _instruction_panel = $"../UILabel/InstructionPanel"
@onready var _instruction_message = $"../UILabel/InstructionMessage"
@onready var _instruction_1 = $Instruction1

var instruction_number = -1
var instructions = ["Hii traveller, Welcome to this journey to enlightenment!", "Use Arrow Keys or W/A/S/D to move. Spacebar key to Jump", "Press Shift or H key to launch the powerful Gola from your Dand. It would take some to build. Let it build...", "While the Gola is building, you can Press Shift or H to cancel the build. You have limited amount, use judiciously. Collect more during the journey.", "Gola will protect you from creatures during the journey. However the creatures are only doing self protection", "You can jump over the snake, and you won't get hurt until you contact the forward part of his body", "The less violence and less time you take, easier will be the journey, hostility increases with more time and kills you do.", "Karma's watchful eye, Less yields more, let's simplify.", ""]

func _physics_process(delta):
	if not _instruction_message.get_total_character_count():
		_instruction_panel.hide()
	else:
		_instruction_panel.show()
				
	if instruction_number !=-1 and instruction_number < instructions.size():
		var extra_text = ""
		if instruction_number != instructions.size()-1:
			extra_text = "\n Press K to continue    Press J to Skip"
		_instruction_message.text = instructions[instruction_number] + extra_text
		if Input.is_action_just_pressed("player_continue"):
			instruction_number += 1
		if Input.is_action_just_pressed("player_skip"):
			instruction_number = instructions.size()-1
	
func _on_instruction_1_screen_entered():
	_instruction_message.text = ""
	instruction_number = 0
	_instruction_1.queue_free()
	await get_tree().create_timer(1).timeout
