extends Camera2D

var edge_margin = 10
var scroll_speed = 400
var max_cam_zone = Rect2(Vector2(0,0),Vector2(0,0))
var camera_zoom = {"zoom_step":Vector2(0.1,0.1),"min_zoom":Vector2(0.5, 0.5),"max_zoom":Vector2(2, 2)}

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _process(delta):
	var viewport_size = get_viewport_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	var movement = Vector2.ZERO

	if mouse_pos.x <= edge_margin:
		movement.x -= 1
	elif mouse_pos.x >= viewport_size.x - edge_margin:
		movement.x += 1

	if mouse_pos.y <= edge_margin:
		movement.y -= 1
	elif mouse_pos.y >= viewport_size.y - edge_margin:
		movement.y += 1
	
	position += movement.normalized() * scroll_speed * delta
	
	position.x = clamp(position.x, max_cam_zone.position.x, max_cam_zone.position.x + max_cam_zone.size.x)
	position.y = clamp(position.y, max_cam_zone.position.y, max_cam_zone.position.y + max_cam_zone.size.y)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_at_mouse(-1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN :
			zoom_at_mouse(1)

func zoom_at_mouse(ch):
	var old_zoom = zoom
	
	var new_zoom = clamp(zoom + ch*camera_zoom["zoom_step"], 
								camera_zoom["min_zoom"], 
								camera_zoom["max_zoom"])
	var mouse_pos_world = get_global_mouse_position()
	zoom = new_zoom

	position += (mouse_pos_world - position) * (1.0 - old_zoom.x / new_zoom.x)
