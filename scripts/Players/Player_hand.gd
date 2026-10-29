extends Base_Hand

func set_visual():
	var weight = On_Hand[0].size.x/2
	var height = 850
	var hand_center = 950 - (On_Hand.size()/2)*weight
	for x in On_Hand.size():
		On_Hand[x].position = Vector2(hand_center+weight*x,height)
		On_Hand[x].face_Up()
