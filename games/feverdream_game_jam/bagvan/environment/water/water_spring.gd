class_name WaterSpring
extends Node2D


var velocity := 0.0
var force := 0.0
var height := 0.0
var target_height := 0.0


func initialize(x_position: float) -> void:
	height = position.y
	target_height = position.y
	velocity = 0.0
	position.x = x_position


func water_update(spring_constant: float, dampening: float) -> void:
		height = position.y
		var x := height - target_height
		var loss := -dampening * velocity
		
		force = -spring_constant * x + loss
		velocity += force
		position.y += velocity

