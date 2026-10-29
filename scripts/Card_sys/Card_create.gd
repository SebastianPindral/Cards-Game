extends Node2D
@onready var num_1: Sprite2D = $"../Front/Num1"
@onready var num_2: Sprite2D = $"../Front/Num2"


func Create(N,C) -> void:
	set_num(num_1,N,C)
	set_num(num_2,N,C)

func set_num(num,N,C):
	num.texture = QuickLoad.get_icons(N)
	if C == "Karo" or C == "Kier":
		num.modulate = Color(1,0,0)
	else:
		num.modulate = Color(0,0,0)
	set_size(num)

func set_size(sprite:Sprite2D):
	var target_size = Vector2(15,15)
	var tex_size = sprite.texture.get_size()
	sprite.scale = target_size / tex_size
