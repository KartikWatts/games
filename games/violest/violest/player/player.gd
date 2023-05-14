extends CharacterBody2D


signal magic_ball_shoot(magic_ball_scene, location)

const CAMERA_MARGIN := 500
const CAMERA_SHIFT_TIME := 1.5
const WAND_MAGIC_MARGIN = 35
const SIT_DOWN_MARGIN = 50

var player_health = Game.player_health
var player_speed = Game.player_speed
var player_jump_velocity = Game.player_jump_velocity
var magic_ball = preload("res://player/magic_ball.tscn")

@onready var _animation_player = $AnimationPlayer
@onready var _sprite_2d = $Sprite2D
@onready var _collision_shape = $CollisionShape2D
@onready var _wand_marker = $WandMarker
@onready var _shoot_timer = $ShootTimer
@onready var _attack_progress = $AttackProgress
@onready var _player_hurt_box = $PlayerHurtBox
@onready var _magic_ball = $MagicBall
@onready var _main_camera = $MainCamera

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attack_initiated = false
var face_direction = Game.player_face_direction
var is_sitting = false
var is_hurting = false
var is_dead = false

func _ready():
	self.global_position = Game.player_global_position
	set_wand_marker_position(1)
	_attack_progress.position = _collision_shape.position - Vector2(_collision_shape.shape.get_rect().size.x/2, _collision_shape.shape.get_rect().size.y/2 + WAND_MAGIC_MARGIN)
	_magic_ball.hide()
	_shoot_timer.wait_time = Game.player_attack_launch_time
		
func _process(delta):
	if self.global_position.y > 500:
		Game.load_game()
	if Input.is_action_just_pressed("player_attack"):
		if not is_attack_initiated:
			var tween = get_tree().create_tween()
			is_attack_initiated = true
			_attack_progress.show()
			_magic_ball.show()
			_magic_ball.modulate = 0
			tween.parallel().tween_property(_magic_ball, "modulate", Color(1,1,1,1), Game.player_attack_launch_time)
			tween.parallel().tween_property(_attack_progress, "value", 100, Game.player_attack_launch_time)
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
		_magic_ball.hide()
		_attack_progress.hide()
	
	if not is_dead:
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
			velocity.y = player_jump_velocity
			if is_attack_initiated:
				_animation_player.play("attack_jump")
			else:
				_animation_player.play("jump_up")
		
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction == -1:
			face_direction = -1
			_sprite_2d.flip_h = true
			set_wand_marker_position(direction)
			set_camera_position(direction)
		elif direction == 1:
			face_direction = 1
			set_wand_marker_position(direction)		
			set_camera_position(direction)
			_sprite_2d.flip_h = false
		
		Game.player_face_direction = face_direction
		
		if direction:
			velocity.x = direction * player_speed
			if velocity.y == 0:
				if is_attack_initiated:
					_animation_player.play("attack_walk")
				else:
					_animation_player.play("walk")
		else:
			velocity.x = move_toward(velocity.x, 0, player_speed)
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
	_magic_ball.position = Vector2((_collision_shape.shape.get_rect().size.x/2 + WAND_MAGIC_MARGIN - 10) * direction, - WAND_MAGIC_MARGIN - 10)
	
func set_camera_position(direction):
	var tween = get_tree().create_tween()
	tween.tween_property(_main_camera, "position", Vector2(CAMERA_MARGIN * direction, -65), CAMERA_SHIFT_TIME)

func shoot():
	magic_ball_shoot.emit(magic_ball, _wand_marker.global_position, face_direction)


func _on_shoot_timer_timeout():
	shoot()
	Game.magic_balls_count -= 1
	is_attack_initiated = false
	
func hurt():
	if not is_hurting:
		print("HURT")
		Game.player_health -= 1
		if Game.player_health == 0:
			die()
		else:
			is_hurting = true
			position = position + Vector2(-40 * face_direction, -30)
			self.modulate.a = 0.5
			await get_tree().create_timer(0.2).timeout
			self.modulate.a = 1
			await get_tree().create_timer(0.2).timeout
			self.modulate.a = 0.5
			await get_tree().create_timer(0.2).timeout
			self.modulate.a = 1
			await get_tree().create_timer(0.5).timeout
			is_hurting = false

func die():
	is_dead = true
	_animation_player.play("die")
	await _animation_player.animation_finished
	queue_free()
