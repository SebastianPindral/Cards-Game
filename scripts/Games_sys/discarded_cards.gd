extends Node2D
@onready var table: Node2D = $".."

var Dis_poz = Vector2(900,450)

func _init() -> void:
	position = Dis_poz
	add_to_group("Discarded")

func Set_poz(c):
	SMen.Move_Anim(c,position,randf_range(-PI, PI),.2)
	c.where_is("Discard",position)
