extends Node2D

@onready var water_spring_scene: PackedScene = preload("res://environment/water/water_spring.tscn")
@onready var water_polygon: Polygon2D = $WaterPolygon

const PASSES := 8
const DISTANCE_BETWEEN_SPRINGS := 32
const NUMBER_OF_SPRINGS := 8

@export var k := 0.015
@export var d := 0.03
@export var spread := 0.0002
@export var depth := 1000

var target_height := global_position.y 
var bottom := target_height + depth

var springs: Array[WaterSpring] = []

func _ready() -> void:
	for i in range(NUMBER_OF_SPRINGS):
		var x_position:float = NUMBER_OF_SPRINGS * i
		var water_spring_instance = water_spring_scene.instantiate() as WaterSpring
		
		add_child(water_spring_instance)
		springs.append(water_spring_instance)
		water_spring_instance.initialize(x_position)
		
	splash(2, 5)
	
	
func _physics_process(delta: float) -> void:
	for spring: WaterSpring in springs:
		spring.water_update(k, d)
	
	var left_deltas = []
	var right_deltas = []

	for i in range(springs.size()):
		left_deltas.append(0)
		right_deltas.append(0)
	
	for j in PASSES:
		for i in range(springs.size()):
			if i > 0:
				left_deltas[i] = spread * (springs[i].height - springs[i-1].height)
				springs[i-1].velocity += left_deltas[i]
			if i < springs.size()-1:
				right_deltas[i] = spread * (springs[i].height - springs[i+1].height)
				springs[i+1].velocity += right_deltas[i]
	
	draw_water_body()

func draw_water_body():
	var surface_points = []
	
	for i in range(springs.size()):
		surface_points.append(springs[i].position)

	var first_index := 0
	var last_index := surface_points.size()-1
	
	var water_polygon_points = surface_points
	
	water_polygon_points.append(Vector2(surface_points[last_index].x, bottom))
	water_polygon_points.append(Vector2(surface_points[first_index].x, bottom))

	water_polygon_points = PackedVector2Array(water_polygon_points)
	

func splash(index, speed):
	if index >= 0 and index < springs.size():
		springs[index].velocity += speed
