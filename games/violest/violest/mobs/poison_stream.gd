class_name PoisonStream
extends Area2D

@export var speed = 600

var direction = 1

func _physics_process(delta):
	global_position.x += speed * delta * direction


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area is Player:
		area.hurt()
		blast()
		
func blast():
	queue_free()
	

