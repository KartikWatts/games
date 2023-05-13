extends Node

const PLAYER_MAX_HEALTH := 5.0

@export var game_difficulty := 1.0

@export var player_health := 5.0
@export var player_speed := 300.0
@export var player_jump_velocity := -620.0 
@export var player_attack_launch_time := 1.0

@export var magic_balls_count := 20

@export var snake_health := 1.0 * self.game_difficulty
@export var snake_speed := 250.0 * self.game_difficulty
@export var snake_attack_range := 450.0 * self.game_difficulty
@export var snake_attack_launch_time := 2.0
