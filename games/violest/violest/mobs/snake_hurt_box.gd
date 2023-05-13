class_name Enemy
extends Area2D
	
func hurt():
	get_parent().hurt()


func _on_area_entered(body):
	if body is Player:
		body.hurt()
