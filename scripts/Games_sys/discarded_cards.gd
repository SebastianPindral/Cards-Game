extends Node2D
@onready var table: Node2D = $".."

var Dis_poz = Vector2(920,450)

func _init() -> void:
	position = Dis_poz
	add_to_group("Discarded")

func Set_poz(c):
	c.position = position
	c.rotation = randf_range(0.0, TAU)
