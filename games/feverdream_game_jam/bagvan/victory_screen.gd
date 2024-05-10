extends Control

@onready var button: Button = %Button


func _ready() -> void:
	button.pressed.connect(_on_button_pressed)


func _on_button_pressed():
	Game.restart()
