extends Area2D
class_name Card_Hitbox
@onready var card: ONE_Card = $".."
var size_y

func _ready() -> void:
	mouse_entered.connect(enter)
	mouse_exited.connect(exiter)
	size_y = card.size.y/2

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	get_viewport().set_input_as_handled()
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				Click()
			else:
				Off_Click()

func enter():
	if $"..".state == "player":
		card.position.y -= size_y
		position.y += size_y

func exiter():
	if $"..".state == "player":
		card.position.y += size_y
		position.y -= size_y

func Click():
	card.Use()

func Off_Click():
	pass
