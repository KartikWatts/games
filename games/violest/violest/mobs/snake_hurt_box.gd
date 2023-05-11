class_name Enemy
extends Area2D
	
func hurt():
	get_parent().queue_free()


func _on_area_entered(body):
	if body is Player:
		body.hurt()
