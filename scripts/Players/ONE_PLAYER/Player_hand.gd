extends Node2D
@onready var player: Base_Hand = $"."

func set_visual(On_Hand,_numer):
	if On_Hand.size()==0:return
	var weight = On_Hand[0].size.x/3
	var height = 850.0
	var hand_center = 950.0 - (float(On_Hand.size())/2)*weight
	for x in On_Hand.size():
		On_Hand[x].position = Vector2(hand_center+weight*x,height)
		On_Hand[x].face_Up()
