extends Node2D

class_name Base_Hand
@onready var hand: Node2D = $Hand
var typ
var On_Hand = []
var numer = 0
func set_this(t,num=0):
	typ = t
	var HostHand = load("res://scripts/Players/ONE_PLAYER/Host_hand.gd")
	var PlayerHand = load("res://scripts/Players/ONE_PLAYER/Player_hand.gd")
	match typ:
		"player":
			hand.set_script(PlayerHand)
		"host":
			hand.set_script(HostHand)
			numer = num

func take_cards(cards:Array):
	for c in cards:
		c.where_is(typ)
		On_Hand.append(c)
	sort_hand(true)
	hand.set_visual(On_Hand,numer)

func sort_hand(oper): # oper-false sortuj rosnaco / oper-true sortuj kolorami
	if oper: On_Hand.sort_custom(func(a, b): return (a.Data["Color"] < b.Data["Color"] 
			 or (a.Data["Color"] == b.Data["Color"] and a.Data["Number"] < b.Data["Number"])))
	else: On_Hand.sort_custom(func(a, b): return a.Data["Number"] < b.Data["Number"])
	for i in range(On_Hand.size()):
		var node = On_Hand[i]
		var parent = node.get_parent()
		if parent:
			parent.move_child(node, i)
