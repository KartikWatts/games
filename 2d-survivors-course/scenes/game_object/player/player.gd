extends CharacterBody2D

@onready var _collision_area: Area2D = $CollisionArea2D
@onready var _health_component: HealthComponent = $HealthComponent
@onready var _damage_interval_timer: Timer = $DamageIntervalTimer
@onready var _health_bar: ProgressBar = $HealthBar
@onready var _abilities = $Abilities
@onready var _animation_player = $AnimationPlayer
@onready var _visuals = $Visuals
@onready var velocity_component = $VelocityComponent

@export var arena_time_manager: ArenaTimeManager

var number_colliding_bodies = 0
var base_speed = 0


func _ready():
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)
	base_speed = velocity_component.max_speed
	
	_collision_area.body_entered.connect(on_body_entered)
	_collision_area.body_exited.connect(on_body_exited)
	_damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	_health_component.health_decreased.connect(on_health_decreased)
	_health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()


func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if movement_vector.x !=0 or movement_vector.y!=0:
		_animation_player.play("walk")
	else:
		_animation_player.play("RESET")

	var move_sign = sign(movement_vector.x)
	if move_sign != 0:
		_visuals.scale = Vector2(move_sign, 1)


func get_movement_vector():
	#var movement_vector = Vector2.ZERO
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)


func check_deal_damage():
	if number_colliding_bodies == 0 || !(_damage_interval_timer.is_stopped()):
		return
	
	_health_component.damage(1)
	_damage_interval_timer.start()


func update_health_display():
	_health_bar.value = _health_component.get_health_percent()	


func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()

func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1


func on_damage_interval_timer_timeout():
	check_deal_damage()


func on_health_decreased():
	GameEvents.emit_player_damaged()
	update_health_display()	
	$RandomStreamPlayer2DComponent.play_random()


func on_health_changed():
	update_health_display()


func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is Ability:
		var ability = ability_upgrade as Ability
		_abilities.add_child(ability.ability_controller_scene.instantiate())
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * (current_upgrades["player_speed"]["quantity"] * 0.1))


func on_arena_difficulty_increased(arena_difficulty):
	var is_difficulty_increased_by_30 = arena_difficulty % 6 == 0
	
	if is_difficulty_increased_by_30:
		#print("regenerates health at time:", arena_difficulty * 5)
		var health_regeneration_count = MetaProgression.get_upgrade_count("health_regeneration")
		_health_component.heal(health_regeneration_count)
		update_health_display()
