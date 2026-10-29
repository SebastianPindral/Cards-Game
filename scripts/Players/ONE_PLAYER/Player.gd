extends Node2D

class_name Base_Hand
@onready var hand: Node2D = $Hand

var typ = ""
var On_Hand = []
var numer = 0

func set_this(t,num=0):
	typ = t
	add_to_group(t)
	numer = num
	match numer:
		0:	global_position = Vector2(900,850)
		1:
			global_position = Vector2(100,450)
			rotation = PI/2
		2:	global_position = Vector2(900,100)
		3:
			global_position = Vector2(1800,450)
			rotation = -PI/2

func take_cards(cards:Array):
	for c in cards:
		c.Used.connect(Use_Card.bind(c),CONNECT_DEFERRED | CONNECT_ONE_SHOT)
		On_Hand.append(c)
	sort_hand(true)
	hand.set_visual(On_Hand,typ,numer)

func Use_Card(card):
	get_tree().call_group("Table", "Card_is_Used", card)
	On_Hand.erase(card)
	hand.set_visual(On_Hand,typ,numer)

func sort_hand(oper): # oper-false sortuj rosnaco / oper-true sortuj kolorami
	if oper: On_Hand.sort_custom(func(a, b): return (a.Data["Color"] < b.Data["Color"] 
			 or (a.Data["Color"] == b.Data["Color"] and a.Data["Number"] < b.Data["Number"])))
	else: On_Hand.sort_custom(func(a, b): return a.Data["Number"] < b.Data["Number"])
	for i in range(On_Hand.size()):
		var node = On_Hand[i]
		var parent = node.get_parent()
		if parent:
			parent.move_child(node, i)
