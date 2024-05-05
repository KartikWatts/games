extends Node2D

const NORMAL_SPEED := 500.0
const BOOST_SPEED := 1400.0
const STEERING_FACTOR := 3.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var idle_timer: Timer = $IdleTimer
@onready var special_timer: Timer = $SpecialTimer

var special_ability_applied := false
var max_speed  := NORMAL_SPEED
var velocity := Vector2.ZERO

func _ready() -> void:
	idle_timer.timeout.connect(_on_idle_timer_timeout)
	special_timer.timeout.connect(_on_special_timer_timeout)


func _process(delta: float) -> void:
	var direction := Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	if direction.length() > 1.0:
		direction = direction.normalized()
	
	if Input.is_action_just_pressed("special_ability"):
		max_speed = BOOST_SPEED
		special_timer.start()
		special_ability_applied = true
		
	if special_ability_applied:
		if direction.length() == 0.0:
			direction = Vector2.UP
	
	var desired_velocity = max_speed * direction
	var steering_vector = desired_velocity - velocity
	
	velocity += steering_vector * STEERING_FACTOR * delta
	position += velocity * delta
	
#ADJUST SPRITE FLIP BASED ON VELOCITY
	sprite_2d.flip_v = velocity.x < 0
	
	if direction.length() > 0.0:
		if special_ability_applied:
			animation_player.play("special")
		else:
			animation_player.play("move")
		rotation = velocity.angle()
		if !idle_timer.is_stopped():
			idle_timer.stop()
	else:
		if idle_timer.is_stopped():
			idle_timer.start()


func _on_idle_timer_timeout():
	animation_player.play("idle")


func _on_special_timer_timeout() -> void:
	max_speed = NORMAL_SPEED
	special_ability_applied = false
