extends Node2D

class_name Base_Hand
@onready var hand: Node2D = $Hand
@onready var conture: Node2D = $conture
var info_point_place

var typ = ""#typ gracza
var On_Hand = []#karty na rece
var On_Hold = []#karty podniesione do grupowego rzucenia
var numer
func _ready() -> void:
	GM.Stack_number.connect(set_label)

func set_this(t,num=0):
	typ = t
	numer = num
	add_to_group(t)
	set_poz(450,num)

func set_poz(dis: float, index: int):
	var angle_step = TAU / GM.Player_count()
	var angle = angle_step * index + PI
	position =  GM.Dis_poz + Vector2(0, -dis).rotated(angle)
	rotation = (position - GM.Dis_poz).angle() - PI/2
	draw_conture(dis,angle_step)
	add_info_point()

func add_info_point():
	var new = load("res://Prefabs/UI/point_info.tscn").instantiate()
	info_point_place = new
	conture.add_child(new)

func draw_conture(dis:float,angle_step):
	var new = Line2D.new()
	var con_width = 2*(dis*0.68)*tan(angle_step/2)
	new.points = [Vector2(con_width/2.0,0),Vector2(-con_width/2.0,0)]
	new.width = 10
	new.default_color = Color(1, 1, 1)
	conture.add_child(new)
	new.z_index = -4096 
	new.z_as_relative = false

func take_cards(cards:Array):
	for c in cards:
		c.Used.connect(Use_Card,CONNECT_DEFERRED)
		c.Holdered.connect(holded_cards)
		On_Hand.append(c)
		c.legal(GM.Game.Legality_Check(c))
	sort_hand(true)
	hand.set_visual(On_Hand,typ)

func Use_Card():
	for c in On_Hand:
		if c.is_hold[1] and not On_Hold.has(c):
			On_Hold.append(c)
			break
	var dupli = On_Hold.duplicate()
	
	for H in On_Hold:
		H.Holdered.disconnect(holded_cards)
		H.Used.disconnect(Use_Card)
		On_Hand.erase(H)
		H.reset()
	On_Hold.clear()
	hand.set_visual(On_Hand,typ)
	
	GM.Game.Check_Hand(1,numer,On_Hand)
	GM.throw_card(dupli)

func holded_cards(card):
	if card.is_hold[0]:
		On_Hold.append(card)
	else: 
		On_Hold.erase(card)
	GM.Game.Can_Hold(On_Hand,On_Hold)

func play():
	if typ == "host":
		await SMen.wait_with_pause(1)
		Check_Hand()
		var x = 0
		var xx = 0
		if On_Hand.size()>0: 
			for c in On_Hand:
				if c.legality:
					xx = c
					On_Hold.append(c)
					x = 0
					break
				else:
					x = 1
		else: x = 1
		match x:#na razie losowo / poprawic
			0:
				if (randi()% 100 + 1) <= 0:GM.Game.Knock_Knock(numer)
				xx.Use() #rzucenie karty
				await get_tree().process_frame
				GM.Game.Enemy_SI(xx)
			1:GM.Deal_Stack_Cards(numer) #dobieranie karty ze stosu
	elif typ == "player":
		Check_Hand()

func Check_Hand():
	await GM.Game.Check_Hand(0,numer,On_Hand)
	for c in On_Hand:
		c.legal(GM.Game.Legality_Check(c))

func sort_hand(oper): # oper-false sortuj rosnaco / oper-true sortuj kolorami
	if oper: On_Hand.sort_custom(func(a, b): return (a.Data["Color"] < b.Data["Color"] 
			 or (a.Data["Color"] == b.Data["Color"] and a.Data["Number"] < b.Data["Number"])))
	else: On_Hand.sort_custom(func(a, b): return a.Data["Number"] < b.Data["Number"])
	for i in range(On_Hand.size()):
		var node = On_Hand[i]
		var parent = node.get_parent()
		if parent:
			parent.move_child(node, i)

func set_label(_vari=0):
	var turn = GM.Players[numer][1]
	if turn != 0 and turn != -PI:
		info_point_place.label.text = str(turn)
	else:
		info_point_place.label.text = ""

func set_info_color(col):
	info_point_place.set_info_color(col)
