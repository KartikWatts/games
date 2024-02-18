extends Node

const BASE_DAMAGE = 15
const SPAWN_RADIUS = 100

@export var anvil_ability_scene: PackedScene

@onready var timer: Timer = $Timer

var additional_anvil_count = 0

func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var spawn_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_angle = 360.0/(additional_anvil_count + 1) 
	var spawn_position_variation =  randf_range(0, SPAWN_RADIUS)
	
	for i in additional_anvil_count + 1:
		var adjusted_spawn_direction = spawn_direction.rotated(deg_to_rad(i * spawn_angle))
		var spawn_position = player.global_position + adjusted_spawn_direction * spawn_position_variation
		
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
		var result =  get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters) as Dictionary

		if not result.is_empty():
			spawn_position = result["position"]
		
		var anvil_ability_instance = anvil_ability_scene.instantiate() as AnvilAbility
		var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
		foreground_layer.add_child(anvil_ability_instance)
		anvil_ability_instance.global_position = spawn_position
		anvil_ability_instance.hitbox_component.damage = BASE_DAMAGE


func on_ability_upgrade_added(upgrade, current_upgrades):
	if upgrade.id == "anvil_count":
		additional_anvil_count = current_upgrades["anvil_count"]["quantity"]
