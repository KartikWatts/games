extends CharacterBody2D

const SPEED = 300.0
const ATTACK_RANGE = 500

@onready var _animation_player = $AnimationPlayer
@onready var _sprite_2d = $Sprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = -1

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_wall() or not $FloorCheckRay.is_colliding() and is_on_floor():
		direction *= -1
	if $PlayerCheckRay.is_colliding():
		velocity.x = 0
		_animation_player.play("attack")
	
	else:	
		velocity.x = direction * SPEED
		_animation_player.play("walk")
	
	if direction == -1:
		_sprite_2d.flip_h = false
	elif direction == 1:
		_sprite_2d.flip_h = true
		
	$PlayerCheckRay.target_position.x = position.x * direction + ATTACK_RANGE
			
	move_and_slide()
	
