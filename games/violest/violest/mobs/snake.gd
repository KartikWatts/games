extends CharacterBody2D

const POISON_MARKER_MARGIN = 50

var snake_health := Game.snake_health
var snake_speed := Game.snake_speed
var snake_attack_range := Game.snake_attack_range
var poison_stream = preload("res://mobs/poison_stream.tscn")

@onready var _animation_player = $AnimationPlayer
@onready var _sprite_2d = $Sprite2D
@onready var _player_check_ray = $PlayerCheckRay
@onready var _floor_check_ray = $FloorCheckRay
@onready var _attack_timer = $AttackTimer
@onready var _snake_hurt_box = $SnakeHurtBox
@onready var _poison_marker = $PoisonMarker
@onready var _poison_stream_container = $PoisonStreamContainer
@onready var _collision_shape = $CollisionShape2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = -1
var is_hurting = false
var is_dead = false

func _ready():
	_attack_timer.wait_time = Game.snake_attack_launch_time

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_wall() or not _floor_check_ray.is_colliding() and is_on_floor():
		direction *= -1

	if not is_dead:
		if _player_check_ray.is_colliding():
			if _attack_timer.time_left == 0:
				_attack_timer.start()
				velocity.x = 0
				_animation_player.play("attack")
				await _animation_player.animation_finished
				attack()
				velocity.x = direction * snake_speed / 4
				_animation_player.play("walk")
	#			print(_animation_player.current_animation)
		else:
	#		print(_animation_player.current_animation)		
			_attack_timer.stop()
			velocity.x = direction * snake_speed
			_animation_player.play("walk")
		
		if direction == -1:
			_sprite_2d.flip_h = false
			_floor_check_ray.target_position.x= 0
			set_poison_marker_position(direction)
			_snake_hurt_box.scale = Vector2(1,1)		
		elif direction == 1:
			_sprite_2d.flip_h = true
			set_poison_marker_position(direction)
			_snake_hurt_box.scale = Vector2(-1,1)
			
		_player_check_ray.target_position.x = snake_attack_range * direction
			
		move_and_slide()

func attack():
	var poison_stream_instance = poison_stream.instantiate()
	poison_stream_instance.direction = direction
	poison_stream_instance.global_position = _poison_marker.position
	_poison_stream_container.add_child(poison_stream_instance)

func set_poison_marker_position(direction):
	_poison_marker.position.x = (_collision_shape.shape.get_rect().size.x + POISON_MARKER_MARGIN) * direction

func hurt():
	if not is_hurting:
		print("MOB HURT")
		is_hurting = true
		position = position + Vector2(40 * direction, -10)
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

