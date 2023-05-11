class_name Player
extends Area2D

func hurt():
	get_parent().queue_free()
