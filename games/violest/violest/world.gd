extends Node2D

@onready var _player = $Player
@onready var _magic_ball_container = $MagicBallContainer
@onready var _player_health_bar = $UILabel.get_node("PlayerHealthBar")

func _ready():
	_player.magic_ball_shoot.connect(_on_player_magic_ball_shoot)
	_player_health_bar.max_value = Game.PLAYER_MAX_HEALTH
	_player_health_bar.value = Game.player_health

func _physics_process(delta):
	_player_health_bar.value = Game.player_health

func _on_player_magic_ball_shoot(magic_ball_scene, location, direction):
	var magic_ball = magic_ball_scene.instantiate()
	magic_ball.direction = direction
	magic_ball.global_position = location
	_magic_ball_container.add_child(magic_ball)
