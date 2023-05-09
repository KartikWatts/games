extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var _animation_player = $AnimationPlayer
@onready var _sprite_2d = $Sprite2D

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		print("jump up")
		_animation_player.play("jump_up")

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == -1:
		_sprite_2d.flip_h = true
	elif direction == 1:
		_sprite_2d.flip_h = false
	
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			print("walk")
			_animation_player.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			print("idle")
			_animation_player.play("idle")
	
	if velocity.y > 0:
		print("fall down")		
		_animation_player.play("fall_down")
	
	move_and_slide()
