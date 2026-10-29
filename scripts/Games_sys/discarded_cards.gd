extends Node2D
@onready var table: Node2D = $".."

var Dis_poz = Vector2(1000,450)

func _init() -> void:
	add_to_group("Discarded")

func Set_poz(c):
	c.position = Dis_poz
	c.rotation = randf_range(0.0, TAU)
