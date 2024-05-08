class_name Checkpoint
extends Area2D

@export var checkpoint_id: int


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area_entered: Area2D):
	if area_entered.get_parent().is_in_group("player"):
		Game.set_checkpoint(checkpoint_id)
		queue_free()
