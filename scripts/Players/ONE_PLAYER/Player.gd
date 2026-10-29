extends Node2D

class_name Base_Hand
@onready var hand: Node2D = $Hand

var typ = ""#typ gracza
var On_Hand = []#karty na rece
var numer
func set_this(t,num=0):
	typ = t
	numer = num
	add_to_group(t)
	
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
	hand.set_visual(On_Hand,typ)

func Use_Card(card):
	get_tree().call_group("Table", "Card_is_Used", card)
	On_Hand.erase(card)
	hand.set_visual(On_Hand,typ)

func play():
	if typ == "host":
		await SMen.wait_with_pause(1)
		match randi_range(0,1):#na razie losowo / poprawic
			0:if On_Hand.size()>0:	On_Hand[randi_range(0,On_Hand.size())].Use() #rzucenie karty
			1:GMaster.Deal_Stack_Cards(numer) #dobieranie karty ze stosu

func sort_hand(oper): # oper-false sortuj rosnaco / oper-true sortuj kolorami
	if oper: On_Hand.sort_custom(func(a, b): return (a.Data["Color"] < b.Data["Color"] 
			 or (a.Data["Color"] == b.Data["Color"] and a.Data["Number"] < b.Data["Number"])))
	else: On_Hand.sort_custom(func(a, b): return a.Data["Number"] < b.Data["Number"])
	for i in range(On_Hand.size()):
		var node = On_Hand[i]
		var parent = node.get_parent()
		if parent:
			parent.move_child(node, i)
