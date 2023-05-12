extends CharacterBody2D


signal magic_ball_shoot(magic_ball_scene, location)

const SPEED = 300.0
const JUMP_VELOCITY = -615.0
const WAND_MAGIC_MARGIN = 25
const SIT_DOWN_MARGIN = 50

var magic_ball = preload("res://player/magic_ball.tscn")

@onready var _animation_player = $AnimationPlayer
@onready var _sprite_2d = $Sprite2D
@onready var _collision_shape = $CollisionShape2D
@onready var _wand_marker = $WandMarker
@onready var _shoot_timer = $ShootTimer
@onready var _attack_progress = $AttackProgress
@onready var _player_hurt_box = $PlayerHurtBox

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attack_initiated = false
var face_direction = 1
var is_sitting = false

func _ready():
	set_wand_marker_position(1)
	_attack_progress.position = _collision_shape.position - Vector2(_collision_shape.shape.get_rect().size.x/2, _collision_shape.shape.get_rect().size.y/2 + WAND_MAGIC_MARGIN)

func _process(delta):
	if Input.is_action_just_pressed("player_attack"):
		if not is_attack_initiated:
			var tween = get_tree().create_tween()
			is_attack_initiated = true
			_attack_progress.show()
			tween.tween_property(_attack_progress, "value", 100, 1)
			_shoot_timer.start()
		else:
			is_attack_initiated = false
			_attack_progress.value = 0
			_shoot_timer.stop()
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if _shoot_timer.is_stopped():
		_attack_progress.value = 0
		_attack_progress.hide()
	
	if Input.is_action_just_pressed("ui_up"):
		is_sitting = false
	if velocity == Vector2.ZERO:
		if Input.is_action_just_pressed("ui_down"):
			is_sitting = true
	else:
		is_sitting = false
	
	if is_sitting == true:
		_player_hurt_box.position.y = SIT_DOWN_MARGIN
	else:
		_player_hurt_box.position.y = 0
				
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if is_attack_initiated:
			_animation_player.play("attack_jump")
		else:
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
			if is_attack_initiated:
				_animation_player.play("attack_walk")
			else:
				_animation_player.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			if is_sitting == true:
				if is_attack_initiated:
					_animation_player.play("attack_sit")
				else:
					_animation_player.play("sit")
			else:
				if is_attack_initiated:
					_animation_player.play("attack_idle")
				else:
					_animation_player.play("idle")
	
	if velocity.y > 0:
		if is_attack_initiated:
			_animation_player.play("attack_jump")
		else:		
			_animation_player.play("fall_down")
	
	move_and_slide()

func set_wand_marker_position(direction):
	_wand_marker.position = Vector2((_collision_shape.shape.get_rect().size.x/2 + WAND_MAGIC_MARGIN) * direction, - WAND_MAGIC_MARGIN)

func shoot():
	magic_ball_shoot.emit(magic_ball, _wand_marker.global_position, face_direction)


func _on_shoot_timer_timeout():
	shoot()
	is_attack_initiated = false
