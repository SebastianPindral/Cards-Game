extends Node2D
@onready var area_2d: Area2D = $Area2D

var Stack_Pos = Vector2(50,100)

func _init() -> void:
	add_to_group("Stack")
	GM.Stack_number.connect(set_label)

func Set_Stack(S):
	Stack_Pos = Vector2(50,100)
	var offset = S[0].size.x/50
	for c in S:
		Stack_Pos.x += offset
		SMen.Move_Anim(c,Stack_Pos,0,0.1)
		c.where_is("Stack",Stack_Pos)
	area_2d.position = Stack_Pos
	$Label.position = Stack_Pos-Vector2(-S[0].size.x/2,S[0].size.x/2)
	$Label.size.x = S[0].size.x*2
	$Area2D/CollisionShape2D.shape.size = S[0].size

func set_label(vari):
	if vari > 1:
		$Label.text = "+"+str(vari)
	else:
		$Label.text = ""
