extends Node

@onready var timer = $Timer as Timer

@export var MAX_RANGE: float = 150
@export var sword_ability: PackedScene
var damage = 5
var base_wait_time

# Called when the node enters the scene tree for the first time.
func _ready():
	base_wait_time = timer.wait_time
	#get_node("Timer")
	#$Timer.timeout.connect(on_timer_timeout)
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if (player == null):
		return
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	
	if enemies.size() == 0:
		return
	
# OPTIMIZATION CAN BE DONE HERE RATHER THAN ONLY FILTERING, TRAVERSAL CAN BE DONE TO DO BOTH OPERATIONS IN SINGLE LOOP AND COMPUTATION
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance	
	)
	
	var sword_instance = sword_ability.instantiate() as SwordAbility
	player.get_parent().add_child(sword_instance)
	sword_instance.hitbox_component.damage = damage
	
	sword_instance.global_position = enemies[0].global_position 
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4

	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id != "sword_rate":
		return

	var percent_reduction = current_upgrades["sword_rate"]["quantity"] * 0.1
	timer.wait_time = base_wait_time * (1 - percent_reduction)
	timer.start()