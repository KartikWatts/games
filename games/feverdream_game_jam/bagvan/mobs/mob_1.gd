extends CharacterBody2D

const MOVEMENT_SPEED := 150.0
const ATTACK_SPEED := 250.0
const CHASER_ATTACK_SPEED := 1000.0
const STEERING_FACTOR := 3.0
const WAIT_TIME := 2.0

enum MobType {CHASER, STORMER}
enum Stance {NORMAL, ATTACK, DIE}

@export var mob_type:MobType = MobType.CHASER

@onready var move_timer: Timer = $MoveTimer
@onready var chaser_sense: Area2D = $ChaserSense
@onready var chaser_collision: CollisionShape2D = %ChaserCollision
@onready var stormer_sense: Area2D = $StormerSense
@onready var stormer_collision: CollisionShape2D = %StormerCollision
@onready var hitbox: Area2D = $Hitbox


var stance := Stance.NORMAL
var movement_direction := Vector2.LEFT
var storm_target_position := Vector2.ZERO

func _ready() -> void:
	move_timer.timeout.connect(_on_move_timer_timeout)
	
	if mob_type == MobType.STORMER:
		stormer_collision.disabled = false
		chaser_collision.disabled = true
		stormer_sense.area_entered.connect(_on_area_entered)
		#stormer_sense.area_exited.connect(_on_area_exited)
		hitbox.body_shape_entered.connect(_on_stormer_body_entered)
	else:
		stormer_collision.disabled = true
		chaser_collision.disabled = false
		chaser_sense.area_entered.connect(_on_area_entered)
		chaser_sense.area_exited.connect(_on_area_exited)


func _process(_delta: float) -> void:
	#print(movement_direction, velocity.x)
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
	if mob_type == MobType.STORMER:
		direction = storm_target_position
		direction.y = 0
		
	
	if direction.x >= 0:
		movement_direction = Vector2.LEFT
	else:
		movement_direction = Vector2.RIGHT
	
	accelerate_in_direction(direction)


func accelerate_in_direction(direction: Vector2):
	var attack_speed := ATTACK_SPEED
	if mob_type == MobType.STORMER:
		attack_speed = CHASER_ATTACK_SPEED
	var desired_velocity = direction * attack_speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-STEERING_FACTOR * get_process_delta_time()))


func turn_movement_direction(old_direction: Vector2):
	movement_direction = Vector2.ZERO
	await get_tree().create_timer(WAIT_TIME).timeout
	movement_direction = old_direction * -1
	#print("TURNING MOVEMENT FROM ", old_direction, "TO ", movement_direction)
	rotate(PI)


func _on_move_timer_timeout():
	var old_direction := movement_direction
	turn_movement_direction(old_direction)


func _on_area_entered(area_entered: Area2D):
	#print(area_entered)
	if area_entered.get_parent().is_in_group("player"):
		stance = Stance.ATTACK
	if mob_type == MobType.STORMER:
		storm_target_position = (area_entered.global_position - global_position).normalized()
		move_timer.stop()
		await get_tree().create_timer(2.0).timeout
		rotate(PI)
		move_timer.start()
		stance = Stance.NORMAL


func _on_area_exited(area_exited: Area2D):
	if area_exited.get_parent().is_in_group("player"):
		move_timer.start()
		stance = Stance.NORMAL


func _on_stormer_body_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int):
	if (mob_type != MobType.STORMER or stance != Stance.ATTACK):
		return
	if not body is TileMap:
		return
	var current_tilemap := body as TileMap
	#print(current_tilemap)
	#print(current_tilemap.get_layer_for_body_rid(body_rid))
	current_tilemap.erase_cell(0, current_tilemap.get_coords_for_body_rid(body_rid))
