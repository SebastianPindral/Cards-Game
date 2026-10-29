extends Node2D
@onready var player: Base_Hand = $".."

var holder = []
func set_visual(On_Hand,typ):
	if On_Hand.size()==0:return
	else:
		if holder.size() < On_Hand.size():
			for i in range(holder.size(),On_Hand.size()):
				var new = Node2D.new()
				holder.append(new)
				add_child(new)
	var weight = On_Hand[0].size.x/3
	var start = -( float(On_Hand.size()-1) / 2)*weight
	for x in On_Hand.size():
		holder[x].position = Vector2(start+weight*x,0)
		SMen.Move_Anim(On_Hand[x],holder[x].global_position,get_parent().rotation,0.1)
		On_Hand[x].where_is(typ,holder[x].global_position)
