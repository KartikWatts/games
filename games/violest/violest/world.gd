extends Node2D

@onready var _player = $Player
@onready var _magic_ball_container = $MagicBallContainer
@onready var _player_health_bar = $UILabel.get_node("PlayerHealthBar")
@onready var _game_sound_btn = $UILabel.get_node("Sound")
@onready var _game_no_sound_btn = $UILabel.get_node("NoSound")
@onready var _sounds = $Sounds

func _ready():
	Game.update_game_difficulty(Game.selected_difficulty_level)
	_player.magic_ball_shoot.connect(_on_player_magic_ball_shoot)
	_player_health_bar.max_value = Game.PLAYER_MAX_HEALTH
	_player_health_bar.value = Game.player_health
	if Game.has_game_sound:
		_game_sound_btn.show()
	else:
		_game_sound_btn.hide()
		
func _process(_delta):
	_player_health_bar.value = Game.player_health

func _on_player_magic_ball_shoot(magic_ball_scene, location, direction):
	var magic_ball = magic_ball_scene.instantiate()
	magic_ball.direction = direction
	magic_ball.global_position = location
	_magic_ball_container.add_child(magic_ball)

func _on_back_pressed():
	Game.load_main_menu()


func _on_restart_pressed():
	Game.load_game()


func _on_no_sound_pressed():
	Game.has_game_sound = true
	_game_sound_btn.show()


func _on_sound_pressed():
	Game.has_game_sound = false	
	_game_sound_btn.hide()
	
