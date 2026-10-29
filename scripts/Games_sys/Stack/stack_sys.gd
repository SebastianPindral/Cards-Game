extends Node2D
@onready var area_2d: Area2D = $Area2D


var S_Stack_Pos = Vector2(700,450)
var E_Stack_Pos = S_Stack_Pos

func _init() -> void:
	add_to_group("Stack")

func Set_Stack(S):
	var offset = S[0].size.x/50
	for c in S:
		E_Stack_Pos.x += offset
		c.position = E_Stack_Pos
	area_2d.position = E_Stack_Pos
	$Area2D/CollisionShape2D.shape.size = S[0].size
