extends CanvasLayer

signal transitioned_halfway

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var skip_emit = false


func transition():
	animation_player.play("default")
	print("PLAYING FORWARD")
	await transitioned_halfway
	skip_emit = true
	animation_player.play_backwards("default")
	print("PLAYING BACKWARD")

func emit_transitioned_halfway():
	print("TRANSITION HALFWAY EMITTED")
	print(str("SKIP EMIT: ", skip_emit))
	if skip_emit:
		skip_emit = false
		return
	transitioned_halfway.emit()
