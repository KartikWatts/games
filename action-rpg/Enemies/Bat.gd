extends CharacterBody2D

var knockback= Vector2.ZERO

func _physics_process(delta):
#	knockback= knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback= move_and_slide()

func _on_HurtBox_area_entered(area):
	knockback= area.knockback_vector * 120
#	queue_free()
