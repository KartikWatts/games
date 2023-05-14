extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		_on_play_pressed()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://world.tscn")	
