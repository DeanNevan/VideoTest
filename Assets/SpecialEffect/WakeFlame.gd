extends Node2D


var user

var color = Color.white
var width = 5
var tail_size = 90
var points = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	if points.size() < 2:
		return
	var colors = []
	for i in points.size():
		colors.append(Color(color.r, color.g, color.b, float(i) / points.size()))
	draw_polyline_colors(points, colors, width, true)
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()
	if is_instance_valid(user) and user != null:
		if points.size() < tail_size:
			points.append(user.global_position)
		else:
			points.pop_front()
			points.append(user.global_position)
	else:
		points.pop_front()
		if points.size() < 2:
			queue_free()
	pass
