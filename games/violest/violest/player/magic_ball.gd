extends Area2D

@export var speed = 600
@export var rot_speed = rad_to_deg(5)

func _physics_process(delta):
	global_position.x += speed * delta
	rotation += rot_speed * delta
	


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
