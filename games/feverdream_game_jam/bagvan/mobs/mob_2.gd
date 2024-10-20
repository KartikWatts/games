class_name BirdMob
extends CharacterBody2D

const MOVEMENT_SPEED := 350.0
const ATTACK_SPEED := 1000.0
const POUNCE_SPEED := 1500.0
const POUNCE_RANGE := 300.0
const STEERING_FACTOR := 5.0
const DISTANCE_MARGIN := 100.0

enum Stance {NORMAL, ATTACK, TRAVEL_BACK, DIE}

@onready var move_timer: Timer = $MoveTimer
@onready var area_2d: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var bird_music = preload("res://assets/music/bird.mp3")
var attack_music = preload("res://assets/music/flight_attack.mp3")

var stance := Stance.NORMAL
var movement_direction := Vector2.LEFT
var initial_position := Vector2.ZERO
var player


func _ready() -> void:
	initial_position = global_position
	player = get_tree().get_first_node_in_group("player") as Node2D
	await get_tree().create_timer(randf_range(0,2)).timeout
	
	move_timer.wait_time = randf_range(4,5)
	move_timer.timeout.connect(_on_move_timer_timeout)
	area_2d.area_entered.connect(_on_area_entered)
	#area_2d.area_exited.connect(_on_area_exited)


func _process(_delta: float) -> void:
	if velocity.x > 0:
		sprite_2d.flip_h = true
	elif velocity.x < 0:
		sprite_2d.flip_h = false
	
	if stance == Stance.NORMAL:
		normal_process()
	elif stance == Stance.ATTACK:
		attack_process()
	elif stance == Stance.TRAVEL_BACK:
		travel_back_process()
	
	if is_on_floor():
		stance = Stance.TRAVEL_BACK	
	
	if position.y > Game.WATER_LEVEL - DISTANCE_MARGIN:
		stance = Stance.TRAVEL_BACK
		
	move_and_slide()


func normal_process():
	var desired_velocity = MOVEMENT_SPEED * movement_direction
	var steering_vector = desired_velocity - velocity
	
	velocity += steering_vector * STEERING_FACTOR * get_process_delta_time()


func attack_process():
	if player == null:
		return
	
	var direction = (player.global_position - global_position).normalized()
	if direction.x >= 0:
		movement_direction = Vector2.LEFT
	else:
		movement_direction = Vector2.RIGHT
	
	accelerate_in_direction(direction)


func travel_back_process():
	if global_position.y <= initial_position.y + DISTANCE_MARGIN :
		stance = Stance.NORMAL
		if animation_player.is_playing() == false:
			animation_player.play("normal")
	else:
		accelerate_in_direction(Vector2.UP)


func accelerate_in_direction(direction: Vector2):
	var speed := ATTACK_SPEED
	print(player.global_position.y - global_position.y)
	if player and player.global_position.y - global_position.y < POUNCE_RANGE:
		print("POUNCE ATTACK")
		speed = POUNCE_SPEED
		Game.play_audio(audio_stream_player_2d, attack_music)
		animation_player.play("pounce")
		
	var desired_velocity = direction * speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-STEERING_FACTOR * get_process_delta_time()))


func turn_movement_direction(old_direction: Vector2):
	movement_direction = Vector2.ZERO
	var wait_time = randf_range(1, 1.5)
	await get_tree().create_timer(wait_time).timeout
	movement_direction = old_direction * -1
	if audio_stream_player_2d.playing == false:
			Game.play_audio(audio_stream_player_2d, bird_music)


func _on_move_timer_timeout():
	var old_direction := movement_direction
	turn_movement_direction(old_direction)


func _on_area_entered(area_entered: Area2D):
	if area_entered.get_parent().is_in_group("player"):
		if stance != Stance.TRAVEL_BACK:
			animation_player.play("attack")
			stance = Stance.ATTACK

#
#func _on_area_exited(area_exited: Area2D):
	#if area_exited.get_parent().is_in_group("player"):
		#if stance != Stance.TRAVEL_BACK:
			#move_timer.start()
			#stance = Stance.NORMAL
