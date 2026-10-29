extends Control
signal CH(value)
var Choice_name =""
var shape = [Vector2(0, 0),Vector2(200, 0),Vector2(0, 200),]
var fill_color: Color = Color(1.0, 1.0, 1.0)
var normal_color: Color = Color(1.0, 1.0, 1.0)
var hover_color: Color = Color(1.0, 1.0, 1.0)
var icon: Texture2D
var module = Color(1,1,1)

var normal_size
var hover_size
func set_button(dist,Choice_count,f:Color,path,i:String=""):
	normal_size = dist
	hover_size = dist*1.2
	create_polygon(dist,Choice_count)
	
	fill_color = f
	normal_color = f
	hover_color = f.darkened(0.3)
	icon = load("res://assets/Card_fragment/"+path+i+".png")
	if path == "Numbers/":
		module = Color(0,0,0)
	Choice_name = i

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
		draw_texture_rect(icon, Rect2((Vector2.ZERO - size0/2), size0), false,module)
		draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)

func _unhandled_input(event):
	if Geometry2D.is_point_in_polygon(get_local_mouse_position(), shape):
		hover(hover_color,hover_size)
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			click()
	else:
		if fill_color != normal_color:
			hover(normal_color,normal_size)

func click():
	if get_parent().visible == true:
		CH.emit(Choice_name)

func hover(h_color,h_size):
	fill_color = h_color
	for i in range(0,shape.size()):
		shape[i] = shape[i].normalized() * h_size
	queue_redraw()

func create_polygon(dist,Choice_count):
	shape = [Vector2(0, 0)]
	var shape0 = Vector2(dist,0)
	var shape1 = shape0.rotated(TAU/Choice_count)
	shape.append(shape0)
	for i in range(1,11):
		shape.append(shape0.rotated((TAU/Choice_count)*(i*0.09)))
	shape.append(shape1)
	shape.append(shape[0])

func get_polygon_center(points: Array) -> Vector2:
	var sum = Vector2()
	var total_weight = 0.0
	for i in points.size():
		var weight = 1.0
		if i == 0:
			weight = 3.0
		sum += points[i] * weight
		total_weight += weight
	return sum / total_weight
