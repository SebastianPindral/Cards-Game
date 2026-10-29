extends Area2D

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		get_viewport().set_input_as_handled()
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				Click()
			else:
				Off_Click()


func Click():
	pass

func Off_Click():
	pass
