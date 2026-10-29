extends BaseGame
class_name Makao
var base_conditions = func() -> bool: return (GM.Active_card.Data["Number"] == GM.card.Data["Number"] 
											or GM.Active_card.Data["Color"] == GM.card.Data["Color"])
var getter = func() -> bool: 
	return (GM.card.Data["Number"] in [2,3] or (GM.card.Data["Number"] == 13 and (GM.card.Data["Color"] == 1)))

var stopper = func() -> bool: 
	return GM.card.Data["Number"] == 4

var num_order = func() -> bool: 
	return GM.card.Data["Number"] in [11,Order["Numbers"][1]] #J

var Choice_color = func() -> bool: 
	return (GM.card.Data["Number"] == 14 or GM.card.Data["Color"] == Order["Colors"][1]) #A

var last_card_check = func() -> bool: return (GM.last_take_card.Data["Number"] == GM.card.Data["Number"] 
						or GM.last_take_card.Data["Color"] == GM.card.Data["Color"])

var nope = func() -> bool: return false
var wait_count = 0
var first_card = true

func _init() -> void:
	GM.Deck_size["count_colors"] = 4
	GM.Deck_size["count_numer"] = 13
	#GM.Deck_size["count_decks"] = 1#dac mozliwosc dostosowania
	GM.Deck_size["count_jockers"] = 0
	GM.game_rule["Start_Cards"] = 4#dac mozliwosc dostosowania
	GM.game_rule["Deal_Stack_Cards"] = 1
	Throw_conditions.append(base_conditions)
	Order["Colors"] = [0,0] # pierwsza jest tura urzycia a 2 rzadana wartosc
	Order["Numbers"] = [0,0]

func set_poz_on_discard(c,dis_poz):
	SMen.Move_Anim(c,dis_poz,randf_range(-PI, PI),.2)
	c.where_is("Discard",dis_poz)

func set_game():
	GM.shuffle()
	var one = GM.send(1)
	GM.Active_card = one[0]
	GM.table.Cards_is_Used(one)
	for i in range(0,GM.player_count):
		GM.deal_cards(i,GM.game_rule["Start_Cards"])

func set_choise_obj(Order_obj,Order_type):
	Obj_Order[Order_type] = Order_obj

func get_choise(Order_value,Order_type):
	if Order.has(Order_type):
		Order[Order_type] = [GM.Turn,Order_value]
		GM.table.get_node("Order_info").set_label(Order_type,Order_value)
		stop()
	else:
		print("Error - Order Makao")

func Before_Throw(c):
	if c.Data["Number"] == 11:#J
		Obj_Order["Numbers"].visible = true
		await sig_to_con
	elif c.Data["Number"] == 14:#A
		Obj_Order["Colors"].visible = true
		await sig_to_con

func shift_turn():
	GM.Turn_move(1,not GM.Rotation_direct)

func set_order_state(ord,order_type):
	if Order[order_type][1] == 0:
		Throw_conditions.erase(ord)
		if not Throw_conditions.has(base_conditions):Throw_conditions.append(base_conditions)
	elif not Throw_conditions.has(ord):
		Throw_conditions.append(ord)
		Throw_conditions.erase(base_conditions)

func back_move(order_name:String):
	if ch(order_name):
		GM.Turn_move(2,not GM.Rotation_direct)

func stack_combo(vari):
	if GM.game_rule["Deal_Stack_Cards"]==1: GM.game_rule["Deal_Stack_Cards"]=0
	GM.set_Deal_Stack_Number(ch("M1"),vari)
	if not Throw_conditions.has(getter):
		Throw_conditions.append(getter)

func Throw_card(c):
	if not ch("M16")[0] or not Throw_conditions.has(Choice_color): #brak efektu kart rzuconych na Asa
		match c.Data["Number"]:
			2,3:
				stack_combo(c.Data["Number"])
			4:
				if ch("M1") or wait_count == 0:
					wait_count -= 1
					GM.table.get_node("Order_info").set_label2("",wait_count)
				if not Throw_conditions.has(stopper):	Throw_conditions.append(stopper)
			13:
				match c.Data["Color"]:
					1:
						stack_combo(5)
						back_move("M12")
					2:
						if ch("M18"):
							for id in range(1,GM.player_count+1):
								if id == GM.Turn:continue
								id -= 1
								GM.deal_cards(id,1)
					3: back_move("M13")
	
	match c.Data["Number"]:
		5:	if ch("M4"):		GM.change_rotation_direct()
		10:	if ch("M15"):		shift_turn()
		12:	if ch("M14")[0]:	shift_turn()
		11:	set_order_state(num_order,"Numbers")
		14:	set_order_state(Choice_color,"Colors")
	
	if not ch("M3") and (c.Data["Number"] in [2,3,4] or 
		(c.Data["Number"] == 13 and c.Data["Color"] == 1)):
		Throw_conditions.append(nope)
	end_check(c)

var ifend=0
func end_check(c):
	if ( (c.Data["Number"] != 14 and GM.Turn == Order["Colors"][0]) or 
		 (ch("M5") and c.Data["Number"] != 14) ) and Throw_conditions.has(Choice_color):
		Order["Colors"][1] = 0
		GM.table.get_node("Order_info").set_label("",0)
		Throw_conditions.erase(Choice_color)
		if not Throw_conditions.has(base_conditions):Throw_conditions.append(base_conditions)
	if c.Data["Number"] != 11 and GM.Turn == Order["Numbers"][0] and Throw_conditions.has(num_order):
		Order["Numbers"][1] = 0
		GM.table.get_node("Order_info").set_label("",0)
		Throw_conditions.erase(num_order)
		if not Throw_conditions.has(base_conditions):Throw_conditions.append(base_conditions)
		
	if first_card:
		first_card = false
	elif GM.Players[GM.Turn-1][0].On_Hand.size() == 0 and GM.Players[GM.Turn-1][1] != -PI:
		GM.Players[GM.Turn-1][1] = -PI
		ifend+=1
	
	if ch("M6"):
		if ifend == GM.player_count-1:
			get_tree().quit()
	else:
		if ifend == 1:
			get_tree().quit()

func Get_from_Stack(id):
	if wait_count >= 0:
		GM.deal_cards(id,GM.game_rule["Deal_Stack_Cards"])
	
	# 4 - karta stop
	GM.Players[GM.Turn-1][1] = wait_count
	wait_count = 0
	
	GM.set_Deal_Stack_Number(false,1)
	GM.table.get_node("Order_info").set_label2("",wait_count)
	#Dobieranie do skutku
	if (ch("M2") and Order["Colors"][1]==0 and Order["Numbers"][1]==0 and 
		not Throw_conditions.has(getter) and not Throw_conditions.has(stopper)):
		GM.Turn_move(1,not GM.Rotation_direct)
	
	Throw_conditions.erase(getter)
	Throw_conditions.erase(stopper)
	Throw_conditions.erase(nope)

func Legality_Check(c)->bool:
	GM.card = c
	if (ch("M16")[1] and Throw_conditions.has(Choice_color)
	 and (c.Data["Number"] in [2,3,4] or (c.Data["Number"] == 13 and c.Data["Color"] in [1,2]))): return false
	
	if GM.Active_card.Data["Number"] == 12 and ch("M9"):	return true
	if (GM.card.Data["Number"] == 12 and GM.game_rule["Deal_Stack_Cards"]==1 
		and wait_count >= 0 and Order["Numbers"][1]==0 and ch("M8")):	return true
	return SHelp.if_in_loop(Throw_conditions)

func Can_Hold(On_Hand,On_Hold):#oznacza nielegalnym karty nie pasujące do tych podniesionych
	if not ch("M11"): 
		if On_Hold.size()<=0:
			for Hold_card in On_Hand:
				Hold_card.legal(Legality_Check(Hold_card))
		else:
			for Hold_card in On_Hand:
				Hold_card.legal(false)
			for Hold_card in On_Hold:
				Hold_card.legal(true)
		return
	
	for c in On_Hand:
		c.legal(Legality_Check(c))
		if On_Hold.size()>0 and not Legality_Check(On_Hold[0]):
			for Hold_card in On_Hold:
				Hold_card.reset(Legality_Check(Hold_card))
			On_Hold.clear()
			return
		for Hold_card in On_Hold:
			if Hold_card.Data["Number"] == c.Data["Number"]:
				c.legal(true)
				break
			c.legal(false)
