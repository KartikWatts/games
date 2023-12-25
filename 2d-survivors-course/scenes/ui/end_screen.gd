extends CanvasLayer

@onready var _restart_button: Button = %RestartButton
@onready var _quit_button: Button = %QuitButton
@onready var _title_label: Label = %TitleLabel
@onready var _description_label: Label = %DescriptionLabel

func _ready():
	get_tree().paused = true
	_restart_button.pressed.connect(on_restart_button_pressed)
	_quit_button.pressed.connect(on_quit_button_pressed)


func set_defeat():
	_title_label.text = "Defeat"
	_description_label.text = "You lost!"


func on_restart_button_pressed():
	get_tree().paused = false	
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	

func on_quit_button_pressed():
	get_tree().quit()
