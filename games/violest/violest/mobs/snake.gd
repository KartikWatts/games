extends CharacterBody2D

const SPEED = 300.0

@onready var _animation_player = $AnimationPlayer
@onready var _sprite_2d = $Sprite2D

func _physics_process(delta):
	_animation_player.play("walk")
	var direction = 1
	velocity.x = direction * SPEED
	move_and_slide()
	
