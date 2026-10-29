extends Area2D
class_name Card_Hitbox
@onready var card: ONE_Card = $".."
@onready var colli: CollisionShape2D = $CollisionShape2D

var size_y
func _ready() -> void:
	mouse_entered.connect(enter)
	mouse_exited.connect(exiter)
	size_y = Vector2(0,card.size.y/2)
	colli.shape = colli.shape.duplicate()

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	get_viewport().set_input_as_handled()
	if event is InputEventMouseButton and $"..".state == "player":
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			Click_card()
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			hold_card()

func enter():
	if card.state == "player" and card.legality and not card.is_hold[0]:
		SMen.Move_Anim(card,card.position-size_y,0,.07)
		SMen.Move_Anim(self,size_y/2,0,.07)
		colli.shape.size += size_y
		card.is_hold[1] = true

func exiter():
	if card.state == "player" and card.legality and not card.is_hold[0]:
		SMen.Move_Anim(card,card.shadow_position,0,.07)
		SMen.Move_Anim(self,Vector2(0,0),0,.07)
		colli.shape.size = card.shadow_colli
		card.is_hold[1] = false

func Click_card():
	if GM.Turn == 1 and card.legality:
		card.Use()

func hold_card():
	card.holder()
