extends Node

signal camera_action_triggered(action_value: float)
signal checkpoint_reached(checkpoint_id: int)

enum CameraAction {ZOOM, BOTTOM_LIMIT}

const WATER_LEVEL := 140.0
const WATER_GRAVITY := 1.0
const AIR_GRAVITY := 80.0

var player_spawn_position := Vector2.ZERO


func set_player_spawn_position(position: Vector2):
	print("New Checkpoint Reached. Spawn Position: ", position)
	player_spawn_position = position


func process_camera_action(camera_node: Camera2D, camera_action: CameraAction, action_value: float ):
	match camera_action:
		CameraAction.ZOOM:
			var tween = create_tween()
			tween.tween_property(camera_node, "zoom", Vector2.ONE * action_value, 1)
		CameraAction.BOTTOM_LIMIT:
			camera_node.limit_bottom = action_value
			var tween = create_tween()
			tween.tween_property(camera_node, "offset:y", camera_node.position.y + 250.0, 4.0)

func trigger_camera_action(camera_action: CameraAction, action_value: float):
	camera_action_triggered.emit(camera_action, action_value)


func set_checkpoint(checkpoint_id: int):
	checkpoint_reached.emit(checkpoint_id)


func play_audio(stream_player: Node, audio_stream: AudioStream):
	stream_player.stream = audio_stream
	stream_player.play()
