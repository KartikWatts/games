extends Node2D

@onready var player = $Player
@onready var magic_ball_container = $MagicBallContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	player.magic_ball_shoot.connect(_on_player_magic_ball_shoot)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_magic_ball_shoot(magic_ball_scene, location):
	var magic_ball = magic_ball_scene.instantiate()
	magic_ball.global_position = location
	magic_ball_container.add_child(magic_ball)
