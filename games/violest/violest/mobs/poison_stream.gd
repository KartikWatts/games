class_name PoisonStream
extends Area2D

@onready var _animation_player = $AnimationPlayer

@export var speed = Game.poison_stream_speed

var direction = 1
var is_blasting = false

func _ready():
	_animation_player.play("normal")

func _physics_process(delta):
	if not is_blasting:
		global_position.x += speed * delta * direction


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area is Player:
		area.hurt()
		blast()


func _on_body_entered(body):
	if body is TileMap:
		blast()

		
func blast():
	is_blasting = true
	direction = 0
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,0), 0.2)
	_animation_player.play("blast")
	await  _animation_player.animation_finished	
	queue_free()
	

