extends Node2D
@onready var table: Node2D = $".."

func _init() -> void:
	position = GM.Dis_poz
	add_to_group("Discarded")

func Set_poz(c):
	GM.Game.set_poz_on_discard(c,position)
