extends CanvasLayer

signal transitioned_halfway

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var skip_emit = false


func transition():
	animation_player.play("default")
	await transitioned_halfway
	skip_emit = true
	animation_player.play_backwards("default")


func emit_transitioned_halfway():
	if skip_emit:
		skip_emit = false
		return
	transitioned_halfway.emit()


func transition_to_scene(path_name: String, to_be_paused: bool = false):
	skip_emit = false
	transition()
	await transitioned_halfway
	if to_be_paused:
		get_tree().paused = false
	get_tree().change_scene_to_file(path_name)
