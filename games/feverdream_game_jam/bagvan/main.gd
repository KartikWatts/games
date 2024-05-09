extends Node2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _process(delta: float) -> void:
	if audio_stream_player.playing == false:
		await get_tree().create_timer(2.0).timeout
		audio_stream_player.play()
