extends Button


func _ready():
	pressed.connect(on_connect)
	

func on_connect():
	$RandomStreamPlayerComponent.play_random()
