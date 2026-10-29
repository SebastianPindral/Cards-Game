extends Node2D
@onready var front: Sprite2D = $"../Front"
@onready var polygon_2d: Polygon2D = $"../Polygon2D"
@onready var back: Sprite2D = $"../Back"

func Create(N,C) -> void:
	front.texture = QuickLoad.get_icons(str(N)+"_"+str(C))
	set_size()

func set_size():
	var target_size = get_parent().size
	var tex_size = front.texture.get_size()
	front.scale = target_size / tex_size
	tex_size = back.texture.get_size()
	back.scale = target_size / tex_size
	polygon_2d.polygon = [	Vector2(-(target_size.x/2+1),-(target_size.y/2+1)),
							Vector2((target_size.x/2+1),-(target_size.y/2+1)), 
							Vector2((target_size.x/2+1),(target_size.y/2+1)), 
							Vector2(-(target_size.x/2+1),(target_size.y/2+1))]
