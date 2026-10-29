extends Node2D
@onready var front: Sprite2D = $"../Front"
@onready var polygon_2d: Polygon2D = $"../Polygon2D"
@onready var back: Sprite2D = $"../Back"
@onready var cs: CollisionShape2D = $"../Area2D/CollisionShape2D"

func Create(j,i) -> void:
	var N
	var C
	match i:
		1: C = "Pik"
		2: C = "Kier"
		3: C = "Trefl"
		4: C = "Karo"
	match j:
		11: N = "J"
		12: N = "Q"
		13: N = "K"
		14: N = "A"
		15:
			N = "JOKER"
			C = "RED"
		16:
			N = "JOKER"
			C = "BLACK"
		_:
			N = str(j)
	front.texture = SMen.QL.get_icons(str(N)+"_"+str(C))
	back.texture = SMen.QL.get_icons("Back")
	set_size()

func set_size():
	var target_size = get_parent().size
	SMen.Resize(front,get_parent().size)
	SMen.Resize(back,get_parent().size)
	
	var texture_size = front.texture.get_size()* front.scale
	var shape = cs.shape as RectangleShape2D
	if shape and texture_size:
		shape.size = texture_size
	
	polygon_2d.polygon = [	Vector2(-(target_size.x/2+1),-(target_size.y/2+1)),
							Vector2((target_size.x/2+1),-(target_size.y/2+1)), 
							Vector2((target_size.x/2+1),(target_size.y/2+1)), 
							Vector2(-(target_size.x/2+1),(target_size.y/2+1))]
