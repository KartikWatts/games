extends CharacterBody2D


signal magic_ball_shoot(magic_ball_scene, location)

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const WAND_MAGIC_MARGIN = 25

var magic_ball = preload("res://player/magic_ball.tscn")

@onready var _animation_player = $AnimationPlayer
@onready var _sprite_2d = $Sprite2D
@onready var _collision_shape = $CollisionShape2D
@onready var _wand_marker = $WandMarker
@onready var _shoot_timer = $ShootTimer

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attack_initiated = false
var face_direction = 1

func _ready():
	set_wand_marker_position(1)

func _process(delta):
#	print(_shoot_timer.time_left)
	if Input.is_action_pressed("player_attack"):
		if not is_attack_initiated:
			is_attack_initiated = true
			_shoot_timer.start()
	else:
		is_attack_initiated = false
		_shoot_timer.stop()
		
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		_animation_player.play("jump_up")
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == -1:
		face_direction = -1
		_sprite_2d.flip_h = true
		set_wand_marker_position(direction)
	elif direction == 1:
		face_direction = 1
		set_wand_marker_position(direction)		
		_sprite_2d.flip_h = false
	
	
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
#			print("walk")
			_animation_player.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
#			print("idle")
			_animation_player.play("idle")
	
	if velocity.y > 0:
#		print("fall down")		
		_animation_player.play("fall_down")
	
	move_and_slide()

func set_wand_marker_position(direction):
	_wand_marker.position = Vector2((_collision_shape.shape.get_rect().size.x/2 + WAND_MAGIC_MARGIN) * direction, - WAND_MAGIC_MARGIN)

func shoot():
	magic_ball_shoot.emit(magic_ball, _wand_marker.global_position, face_direction)


func _on_shoot_timer_timeout():
	shoot()
	is_attack_initiated = false
