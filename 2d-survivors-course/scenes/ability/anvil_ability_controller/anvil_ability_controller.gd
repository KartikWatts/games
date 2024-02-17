extends Node

const BASE_DAMAGE = 15
const SPAWN_RADIUS = 100

@export var anvil_ability_scene: PackedScene

@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var spawn_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + (spawn_direction * randf_range(0, SPAWN_RADIUS))
	
	var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
	var result =  get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters) as Dictionary

	if not result.is_empty():
		spawn_position = result["position"]
	
	var anvil_ability_instance = anvil_ability_scene.instantiate() as AnvilAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(anvil_ability_instance)
	anvil_ability_instance.global_position = spawn_position
	anvil_ability_instance.hitbox_component.damage = BASE_DAMAGE
