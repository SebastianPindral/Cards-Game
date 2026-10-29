extends Node2D
@onready var player: Base_Hand = $"."

func set_visual(On_Hand,typ,_numer):
	if On_Hand.size()==0:return
	var weight = On_Hand[0].size.x/3
	var height = get_parent().global_position.y
	var hand_center = get_parent().global_position.x - (float(On_Hand.size())/2)*weight
	for x in On_Hand.size():
		var poz = Vector2(hand_center+weight*x,height)
		SMen.Move_Anim(On_Hand[x],poz,get_parent().rotation,0.1)
		On_Hand[x].where_is(typ,poz)
