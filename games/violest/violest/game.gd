extends Node

const PLAYER_MAX_HEALTH := 5.0

@export var game_difficulty := 1.0

@export var player_health := 50000.0
@export var player_speed := 180.0
@export var player_jump_velocity := -475.0 
@export var player_attack_launch_time := 1.0
@export var player_face_direction := 1

@export var magic_balls_count := 20
@export var magic_ball_speed := 400
@export var poison_stream_speed := 350

@export var snake_health := 1.0 * self.game_difficulty
@export var snake_speed := 140.0 * self.game_difficulty
@export var snake_attack_range := 550.0 * self.game_difficulty
@export var snake_attack_launch_time := 2.4
