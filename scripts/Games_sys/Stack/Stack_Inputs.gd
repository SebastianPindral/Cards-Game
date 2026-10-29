extends Area2D
@onready var table: Node2D = $"../.."


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and GM.Turn == 1:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			Click_card()
			get_viewport().set_input_as_handled()

func Click_card():
	if GM.Stack.size()>0:
		GM.Deal_Stack_Cards(0)
