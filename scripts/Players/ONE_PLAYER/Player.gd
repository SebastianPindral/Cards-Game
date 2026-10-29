extends Node2D

class_name Base_Hand
@onready var hand: Node2D = $Hand

var typ = ""#typ gracza
var On_Hand = []#karty na rece
var On_Hold = []#karty podniesione do grupowego rzucenia
var numer
func set_this(t,num=0):
	typ = t
	numer = num
	add_to_group(t)

func take_cards(cards:Array):
	for c in cards:
		c.Used.connect(Use_Card,CONNECT_DEFERRED | CONNECT_ONE_SHOT)
		c.Holdered.connect(holded_cards)
		On_Hand.append(c)
		c.legal(GM.Legality_Check(c))
	sort_hand(true)
	hand.set_visual(On_Hand,typ)

func Use_Card():
	for c in On_Hand:
		if c.is_hold[1]:
			if not On_Hold.has(c):
				On_Hold.append(c)
			break
	GM.throw_card(On_Hold)
	for H in On_Hold:
		H.Holdered.disconnect(holded_cards)
		On_Hand.erase(H)
		H.reset()
	On_Hold.clear()
	hand.set_visual(On_Hand,typ)

func holded_cards(card):
	if card.is_hold[0]:
		On_Hold.append(card)
	else: 
		On_Hold.erase(card)
	GM.Can_Hold(On_Hand,On_Hold)

func play():
	if typ == "host":
		await SMen.wait_with_pause(1)
		var x = 0
		if On_Hand.size()>0: 
			for c in On_Hand:
				if GM.Legality_Check(c): 
					x = 0
					continue
				else:
					x = 1
		else: x = 1
		match x:#na razie losowo / poprawic
			0:
				var c = On_Hand[randi_range(0,On_Hand.size()-1)]
				while not GM.Legality_Check(c):
					c = On_Hand[randi_range(0,On_Hand.size()-1)]
				c.Use() #rzucenie karty
			1:GM.Deal_Stack_Cards(numer) #dobieranie karty ze stosu
	elif typ == "player":
		Check_Hand()

func Check_Hand():
	for c in On_Hand:
		c.legal(GM.Legality_Check(c))

func sort_hand(oper): # oper-false sortuj rosnaco / oper-true sortuj kolorami
	if oper: On_Hand.sort_custom(func(a, b): return (a.Data["Color"] < b.Data["Color"] 
			 or (a.Data["Color"] == b.Data["Color"] and a.Data["Number"] < b.Data["Number"])))
	else: On_Hand.sort_custom(func(a, b): return a.Data["Number"] < b.Data["Number"])
	for i in range(On_Hand.size()):
		var node = On_Hand[i]
		var parent = node.get_parent()
		if parent:
			parent.move_child(node, i)
