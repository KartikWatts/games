extends CharacterBody2D

const SPEED = 250.0
const ATTACK_RANGE = 450

@onready var _animation_player = $AnimationPlayer
@onready var _sprite_2d = $Sprite2D
@onready var _player_check_ray = $PlayerCheckRay
@onready var _floor_check_ray = $FloorCheckRay
@onready var _attack_timer = $AttackTimer
@onready var _snake_hurt_box = $SnakeHurtBox

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = -1

#func _ready():
#	print($CollisionShape2D.shape.get_rect().size.y)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_wall() or not _floor_check_ray.is_colliding() and is_on_floor():
		direction *= -1

	if _player_check_ray.is_colliding():
		if _attack_timer.time_left == 0:
			_attack_timer.start()
			velocity.x = 0
			_animation_player.play("attack")
#			print(_animation_player.current_animation)
			await _animation_player.animation_finished
			velocity.x = direction * SPEED / 4
			_animation_player.play("walk")
#			print(_animation_player.current_animation)
	else:
#		print(_animation_player.current_animation)		
		_attack_timer.stop()
		velocity.x = direction * SPEED
		_animation_player.play("walk")
	
	if direction == -1:
		_sprite_2d.flip_h = false
		_floor_check_ray.target_position.x= 0
		_snake_hurt_box.scale = Vector2(1,1)		
	elif direction == 1:
		_sprite_2d.flip_h = true
		_snake_hurt_box.scale = Vector2(-1,1)
		
	_player_check_ray.target_position.x = ATTACK_RANGE * direction
		
	move_and_slide()
