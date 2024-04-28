#A stone that will simply fall into the water
extends CharacterBody2D

#the gravity value
var gravity = 35

#so the stone won't accelerate forever
var max_speed = 450

var max_speed_in_water = 200

func _physics_process(delta):
	#at each frame add gravity to our motion vector
	#clamp the motion value to the speed
	#move the stone with move_and_slide
	velocity.y += gravity
	velocity.y = clamp(velocity.y, -max_speed, max_speed)
	move_and_slide()

#initializes the stone at a set position
func initialize(pos):
	global_position = pos

func in_water():
	gravity = gravity / 3.0
	max_speed = max_speed_in_water
