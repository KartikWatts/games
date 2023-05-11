extends Area2D

@export var speed = 700
@export var rot_speed = rad_to_deg(1)

var direction = 1

func _physics_process(delta):
	global_position.x += speed * delta * direction
	rotation += rot_speed * delta
	

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	if area is Enemy:
		area.hurt()
		queue_free()
