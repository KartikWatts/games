extends Area2D

@export var action_value :float
@export var camera_action :Game.CameraAction

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	

func _on_area_entered(area_entered: Area2D):
	if area_entered.get_parent().is_in_group("player"):
		Game.trigger_camera_action(camera_action, action_value)
		#queue_free()
