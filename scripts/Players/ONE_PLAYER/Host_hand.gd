extends Node2D
@onready var host: Base_Hand = $"."

var space
var weight
var height
var hand_center

func set_visual(On_Hand,_typ,numer):
	if On_Hand.size()==0:return
	space = On_Hand[0].size.y/4
	weight = 100
	height = space
	hand_center = 500 - (float(On_Hand.size())/2)*height
	match numer:
		1: 
			for x in On_Hand.size():
				horizontal_hand(On_Hand[x],x)
		2:
			hand_center += 450
			for x in On_Hand.size():
				vertical_hand(On_Hand[x],x)
		3:
			weight = 1800
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
