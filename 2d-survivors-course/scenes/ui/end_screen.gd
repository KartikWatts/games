extends CanvasLayer

@onready var _continue_button: Button = %ContinueButton
@onready var _quit_button: Button = %QuitButton
@onready var _title_label: Label = %TitleLabel
@onready var _description_label: Label = %DescriptionLabel
@onready var panel_container = %PanelContainer


func _ready():
	panel_container.pivot_offset = panel_container.size/2
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	
	get_tree().paused = true
	_continue_button.pressed.connect(on_continue_button_pressed)
	_quit_button.pressed.connect(on_quit_button_pressed)


func set_defeat():
	_title_label.text = "Defeat"
	_description_label.text = "You lost!"
	play_jingle(true)


func play_jingle(defeat: bool = false):
	if defeat:
		$DefeatStreamPlayer.play()
	else:
		$VictoryStreamPlayer.play()


func on_continue_button_pressed():
	preload("res://scenes/ui/meta_menu.tscn")
	ScreenTransition.transition_to_scene("res://scenes/ui/meta_menu.tscn", true)


func on_quit_button_pressed():
	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu.tscn", true)
