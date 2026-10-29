extends Node2D
@onready var host: Base_Hand = $"."

func set_visual(On_Hand,numer):
	if On_Hand.size()==0:return
	var weight
	var height
	var hand_center
	var space = On_Hand[0].size.y/4
	match numer:
		1: 
			weight = 100
			height = space
			hand_center = 500 - (float(On_Hand.size())/2)*height
			for x in On_Hand.size():
				On_Hand[x].position = Vector2(weight,hand_center+height*x)
		2:
			weight = space
			height = 100
			hand_center = 950 - (float(On_Hand.size())/2)*weight
			for x in On_Hand.size():
				On_Hand[x].position = Vector2(hand_center+weight*x,height)
		3:
			weight = 1800
			height = space
			hand_center = 500 - (float(On_Hand.size())/2)*height
			for x in On_Hand.size():
				On_Hand[x].position = Vector2(weight,hand_center+height*x)
