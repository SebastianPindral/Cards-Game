extends Node2D
@onready var table: Node2D = $".."

func _init() -> void:
	position = GM.Dis_poz
	add_to_group("Discarded")

func Set_poz(c):
	SMen.Move_Anim(c,position,randf_range(-PI, PI),.2)
	c.where_is("Discard",position)
