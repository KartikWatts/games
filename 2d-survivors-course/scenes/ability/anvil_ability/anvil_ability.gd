class_name AnvilAbility
extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox_component = $HitBoxComponent as HitBoxComponent

func _ready() -> void:
	animation_player.play("default")
