extends Control
var Choose_name =""
var shape = [Vector2(0, 0),Vector2(200, 0),Vector2(0, 200),]
var fill_color: Color = Color(1.0, 1.0, 1.0)
var normal_color: Color = Color(1.0, 1.0, 1.0)
var hover_color: Color = Color(1.0, 1.0, 1.0)
var icon: Texture2D
var module = Color(1,1,1)
func set_button(dist,choose_count,f:Color,path,i:String=""):
	shape = [Vector2(0, 0)]
	var shape0 = Vector2(dist,0)
	var shape1 = shape0.rotated(TAU/choose_count)
	shape.append(shape0)
	shape.append(shape1)

	fill_color = f
	normal_color = f
	hover_color = f.darkened(0.3)
	icon = load("res://assets/Card_fragment/"+path+i+".png")
	if path == "Numbers/":
		module = Color(0,0,0)
	Choose_name = i

func _ready():
	mouse_filter = Control.MOUSE_FILTER_STOP
	position = GM.Dis_poz
	custom_minimum_size = Vector2(1, 1)

func _draw():
	draw_colored_polygon(shape, fill_color)
	draw_polyline(shape + [shape[0]], Color.BLACK, 2)
	if icon:
		var center = get_polygon_center(shape)
		
		draw_set_transform(center, -rotation, Vector2.ONE)
		var size0 = Vector2(64, 64)
		draw_texture_rect(icon, Rect2(Vector2.ZERO - size0/2, size0), false,module)
		draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)

func _unhandled_input(event):
	if is_point_in_polygon(get_local_mouse_position(), shape):
		fill_color = hover_color
		queue_redraw()
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			click()
	else:
		if fill_color != normal_color:
			fill_color = normal_color
			queue_redraw()

func click():#obslurzyc wybor
	print(Choose_name)

func get_polygon_center(points: Array) -> Vector2:
	var sum = Vector2()
	for p in points:
		sum += p
	return sum / points.size()

func is_point_in_polygon(point: Vector2, polygon: Array) -> bool:
	var inside = false
	var j = polygon.size() - 1
	for i in range(polygon.size()):
		if ((polygon[i].y > point.y) != (polygon[j].y > point.y)) and \
			(point.x < (polygon[j].x - polygon[i].x) * (point.y - polygon[i].y) / (polygon[j].y - polygon[i].y) + polygon[i].x):
			inside = not inside
		j = i
	return inside
