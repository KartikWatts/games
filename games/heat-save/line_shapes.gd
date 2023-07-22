extends RigidBody2D

@onready var _lines := $Lines as Node2D

var _pressed := false
var _current_line: Line2D


func _ready():
	set_freeze_enabled(true)
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_pressed = event.pressed
		
		if _pressed:
			set_freeze_enabled(true)
			_current_line = Line2D.new()
			_current_line.default_color = Color.ORANGE
			_current_line.width = 16.0
			_lines.add_child(_current_line)
		else:
			if _current_line:
				var line_global_position = _current_line.global_position
				var line_poly = Geometry2D.offset_polyline(_current_line.points, _current_line.width / 2, Geometry2D.JOIN_ROUND, Geometry2D.END_ROUND)
				var line_center = get_line_center(_current_line)
				global_position += line_center + _current_line.position
				_current_line.global_position = line_global_position
				for poly in line_poly:
					var collision_shape = CollisionPolygon2D.new()
					collision_shape.polygon = offset_line_points(line_center, poly)
					add_child(collision_shape)
			set_freeze_enabled(false)
			
	if event is InputEventMouseMotion && _pressed:
		_current_line.add_point(event.position)


func offset_line_points(center: Vector2, poly: Array) -> Array:
	var adjusted_points = []
	for point in poly:
		# Moving the collision shape itself doesn't seem to work as well as offsetting the polygon points
		# for putting the collision shape in the right position after moving the rigidbody.
		# Therefore, to have the collision shape appear where drawn, subtract the polygon center from each point
		# to move the point by the amount the rigidbody was moved relative to the original Line2D's position.
		adjusted_points.append(point - center)
	return adjusted_points


func get_line_center(line: Line2D) -> Vector2:
	var center_weight = line.points.size()
	var center = Vector2(0, 0)
	
	for point in line.points:
		center.x += point.x / center_weight
		center.y += point.y / center_weight
	
	return center
