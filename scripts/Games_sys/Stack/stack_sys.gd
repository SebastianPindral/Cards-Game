extends Node2D
@onready var area_2d: Area2D = $Area2D

func _init() -> void:
	add_to_group("Stack")

func Set_Stack(S):
	var Stack_Pos = Vector2(500,450)
	var offset = S[0].size.x/50
	for c in S:
		Stack_Pos.x += offset
		SMen.Move_Anim(c,Stack_Pos,0,0.1)
		c.where_is("Stack",Stack_Pos)
	area_2d.position = Stack_Pos
	$Area2D/CollisionShape2D.shape.size = S[0].size
