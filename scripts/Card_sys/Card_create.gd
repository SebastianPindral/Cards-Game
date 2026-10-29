extends Node2D
@onready var front: Sprite2D = $"../Front"

func Create(N,C) -> void:
	front.texture = QuickLoad.get_icons(str(N)+"_"+str(C))
	set_size(front)

func set_size(sprite:Sprite2D):
	var target_size = Vector2(130,202)
	var tex_size = sprite.texture.get_size()
	sprite.scale = target_size / tex_size
