class_name MagicBall
extends Area2D

@export var speed = Game.magic_ball_speed
@export var rot_speed = rad_to_deg(0.5)

@onready var _animation_player = $AnimationPlayer

var direction = 1
var is_blasting = false

func _ready():
	_animation_player.play("normal")

func _physics_process(delta):
	if not is_blasting:
		global_position.x += speed * delta * direction
		rotation += rot_speed * delta
	

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	if area is Enemy:
		area.hurt()
		blast()
	if area is PoisonStream:
		area.blast()
		blast()
	
func blast():
	is_blasting = true
	direction = 0
	rotation = 0
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,0), 0.4)
	_animation_player.play("blast")
	await  _animation_player.animation_finished	
	queue_free()

