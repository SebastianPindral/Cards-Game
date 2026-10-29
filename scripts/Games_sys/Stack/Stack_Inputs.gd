extends Area2D
@onready var table: Node2D = $"../.."


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and SMen.Turn == 0:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				Click()
				get_viewport().set_input_as_handled()

func Click():
	if table.Stack.size()>0:
		table.players.deal_cards(0,1)
