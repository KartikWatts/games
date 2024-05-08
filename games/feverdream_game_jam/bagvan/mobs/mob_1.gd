extends CharacterBody2D

const MOVEMENT_SPEED := 150.0
const ATTACK_SPEED := 250.0
const STEERING_FACTOR := 3.0
const WAIT_TIME := 2.0

enum Stance {NORMAL, ATTACK, DIE}

@onready var move_timer: Timer = $MoveTimer
@onready var area_2d: Area2D = $Area2D

var stance := Stance.NORMAL
var movement_direction := Vector2.LEFT


func _ready() -> void:
	move_timer.timeout.connect(_on_move_timer_timeout)
	area_2d.area_entered.connect(_on_area_entered)
	area_2d.area_exited.connect(_on_area_exited)


func _process(_delta: float) -> void:
	if stance == Stance.NORMAL:
		normal_process()
	elif stance == Stance.ATTACK:
		attack_process()
	
	if position.y < Game.WATER_LEVEL:
		velocity += Vector2.DOWN * Game.AIR_GRAVITY

	move_and_slide()


func normal_process():
	var desired_velocity = MOVEMENT_SPEED * movement_direction
	var steering_vector = desired_velocity - velocity
	
	velocity += steering_vector * STEERING_FACTOR * get_process_delta_time()


func attack_process():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var direction = (player.global_position - global_position).normalized()
	if direction.x >= 0:
		movement_direction = Vector2.LEFT
	else:
		movement_direction = Vector2.RIGHT
	
	accelerate_in_direction(direction)


func accelerate_in_direction(direction: Vector2):
	var desired_velocity = direction * ATTACK_SPEED
	velocity = velocity.lerp(desired_velocity, 1 - exp(-STEERING_FACTOR * get_process_delta_time()))


func turn_movement_direction(old_direction: Vector2):
	movement_direction = Vector2.ZERO
	await get_tree().create_timer(WAIT_TIME).timeout
	movement_direction = old_direction * -1


func _on_move_timer_timeout():
	var old_direction := movement_direction
	turn_movement_direction(old_direction)


func _on_area_entered(area_entered: Area2D):
	if area_entered.get_parent().is_in_group("player"):
		stance = Stance.ATTACK


func _on_area_exited(area_exited: Area2D):
	if area_exited.get_parent().is_in_group("player"):
		move_timer.start()
		stance = Stance.NORMAL
