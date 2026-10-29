extends Node2D
@onready var host: Base_Hand = $"."

var weight
var height
var hand_center

func set_visual(On_Hand,_typ,numer):
	if On_Hand.size()==0:return
	height = On_Hand[0].size.y/4
	weight = get_parent().global_position.x
	hand_center = get_parent().global_position.y - (float(On_Hand.size())/2)*height
	match numer:
		1: 
			for x in On_Hand.size():
				horizontal_hand(On_Hand[x],x)
		2:
			weight = get_parent().global_position.y
			hand_center = get_parent().global_position.x - (float(On_Hand.size())/2)*height
			for x in On_Hand.size():
				vertical_hand(On_Hand[x],x)
		3:
			for x in On_Hand.size():
				horizontal_hand(On_Hand[x],x)

func vertical_hand(x,y):
	var poz = Vector2(hand_center+height*y,weight)
	x.where_is("host",poz)
	SMen.Move_Anim(x,poz,0,0.2)

func horizontal_hand(x,y):
	var poz = Vector2(weight,hand_center+height*y)
	x.where_is("host",poz)
	SMen.Move_Anim(x,poz,0,0.2)
