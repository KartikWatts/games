extends Node

const PLAYER_MAX_HEALTH := 5.0
const SOFT_DIFFICULTY_LEVEL := 0.5
const BALANCED_DIFFICULTY_LEVEL := 1.0
const HARSH_DIFFICULTY_LEVEL := 1.5
const MAX_DIFFICULT_LEVEL := 2.0

@export var has_game_sound := true

@export var game_difficulty := BALANCED_DIFFICULTY_LEVEL

#@export var player_spawn_position := Vector2(60 , 200)
@export var player_spawn_position := Vector2(4500 , 200)

@export var player_health := 5.0
@export var player_speed := 180.0
@export var player_jump_velocity := -408.0 
@export var player_attack_launch_time := 1.0
@export var player_face_direction := 1

@export var magic_balls_count := 50
@export var magic_ball_speed := 400
@export var poison_stream_speed := 350

@export var snake_health := 0
@export var snake_speed := 150.0
@export var snake_attack_range := 550.0
@export var snake_attack_launch_time := 2
	

func update_game_difficulty(difficulty_value):
	if difficulty_value > MAX_DIFFICULT_LEVEL:
		difficulty_value = MAX_DIFFICULT_LEVEL
	
	if Game.game_difficulty >= Game.HARSH_DIFFICULTY_LEVEL:
		player_speed = 170.0
		player_jump_velocity = -408.0
		snake_attack_launch_time = 2.0
	elif Game.game_difficulty >= Game.BALANCED_DIFFICULTY_LEVEL:
		player_speed = 180.0
		player_jump_velocity = -408.0
		snake_attack_launch_time = 2.0
	elif game_difficulty >= SOFT_DIFFICULTY_LEVEL:
		player_speed = 215.0
		player_jump_velocity = -420.0
		snake_attack_launch_time = 2.5
				
	snake_health = 0 + difficulty_value
	snake_speed = 150.0 * difficulty_value
	if snake_speed >= player_speed - 10:
		snake_speed = player_speed - 10
	snake_attack_range = 550.0 * difficulty_value

func load_game():
	player_health = 5.0
	magic_balls_count = 50
	get_tree().change_scene_to_file("res://world.tscn")

func load_main_menu():
	get_tree().change_scene_to_file("res://main.tscn")

func load_controls_screen():
	get_tree().change_scene_to_file("res://menu/controls.tscn")

func load_credits_screen():
	get_tree().change_scene_to_file("res://menu/credits.tscn")
