extends Node2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var tadpole: CharacterBody2D = $Tadpole
@onready var parallax: Node2D = $Parallax



func _ready() -> void:
	print(Game.player_spawn_position)
	tadpole.global_position = Game.player_spawn_position
	Game.camera_action_triggered.connect(_on_camera_action)
	Game.victory.connect(_on_victory)
	victory_screen.visible = false


func _process(delta: float) -> void:
	if audio_stream_player.playing == false:
		await get_tree().create_timer(2.0).timeout
		audio_stream_player.play()

@onready var victory_screen: Control = $VictoryScreen


func _on_victory():
	print("VICTORY!!!")
	tadpole.freezed = true
	victory_screen.visible = true


func _on_camera_action(camera_action: Game.CameraAction, action_value: float):
	if camera_action == Game.CameraAction.ZOOM:
		parallax.get_node("ParallaxBackground").offset.y = -750.0
