extends CharacterBody2D

const NORMAL_SPEED := 350.0
const BOOST_SPEED := 700.0
const STEERING_FACTOR := 3.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var idle_timer: Timer = $IdleTimer
@onready var special_timer: Timer = $SpecialTimer
@onready var camera_2d: Camera2D = $Camera2D
@onready var checkpoints: Node = %Checkpoints

var special_ability_applied := false
var max_speed  := NORMAL_SPEED


func _ready() -> void:
	idle_timer.timeout.connect(_on_idle_timer_timeout)
	special_timer.timeout.connect(_on_special_timer_timeout)
	Game.camera_action_triggered.connect(_on_camera_action_triggered)
	Game.checkpoint_reached.connect(_on_checkpoint_reached)


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
	
# SETTING GRAVITY FOR CHARACTER
	var gravity_factor := Game.WATER_GRAVITY
	
	if position.y < Game.WATER_LEVEL:
		gravity_factor = Game.AIR_GRAVITY
		if special_ability_applied:
			gravity_factor /= 6.0
		
	velocity += Vector2.DOWN * gravity_factor
	
	move_and_slide()
	
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
	animation_player.play("move")


func _on_camera_action_triggered(camera_action: Game.CameraAction, action_value: float):
	Game.process_camera_action(camera_2d, camera_action, action_value)


func _on_checkpoint_reached(checkpoint_id: int):
	for checkpoint_node: Checkpoint in checkpoints.get_children():
		if checkpoint_node.checkpoint_id == checkpoint_id:
			Game.set_player_spawn_position(checkpoint_node.position)
			checkpoint_node.queue_free()
			break
