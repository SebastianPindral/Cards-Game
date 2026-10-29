extends Node

var Player_count = 4

func _ready() -> void:
	get_viewport().physics_object_picking_sort = true
	get_viewport().physics_object_picking_first_only = true

func Set_Players():
	return Player_count
