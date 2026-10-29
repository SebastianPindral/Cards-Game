extends BaseGame
class_name Makao
var base_conditions = func() -> bool: return (Active_card.Data["Number"] == card.Data["Number"] 
											or Active_card.Data["Color"] == card.Data["Color"])
var getter = func() -> bool: 
	return (card.Data["Number"] in [2,3] or (card.Data["Number"] == 13 and (card.Data["Color"] == 1)))

var stopper = func() -> bool: 
	return card.Data["Number"] == 4

var num_order = func() -> bool: 
	return card.Data["Number"] in [11,Order["Numbers"][1]] #J

var Choice_color = func() -> bool: 
	return (card.Data["Number"] == 14 or card.Data["Color"] == Order["Colors"][1]) #A

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

func set_game(plc):
	player_count = plc
	change_rotation_direct()
	GM.shuffle()
	var one = GM.send(1)
	Active_card = one[0]
	GM.table.Cards_is_Used(one)
	for i in range(0,player_count):
		GM.deal_cards(i,GM.game_rule["Start_Cards"])
	Next_Turn()

func set_choise_obj(Order_obj,Order_type):
	Obj_Order[Order_type] = Order_obj

func get_choise(Order_value,Order_type):
	if Order.has(Order_type):
		Order[Order_type] = [Turn,Order_value]
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

func After_Turn():
	Next_Turn()

func shift_turn():
	Turn_move(1,not Rotation_direct)

func set_order_state(ord,order_type):
	if Order[order_type][1] == 0:
		Throw_conditions.erase(ord)
		if not Throw_conditions.has(base_conditions):Throw_conditions.append(base_conditions)
	elif not Throw_conditions.has(ord):
		Throw_conditions.append(ord)
		Throw_conditions.erase(base_conditions)

func back_move(order_name:String):
	if ch(order_name):
		Turn_move(2,not Rotation_direct)

func true_except_orders(order_num,c,num:int):
	return (ch(order_num)[1] and c.Data["Number"] == num 
	and not Throw_conditions.has(Choice_color) and not Throw_conditions.has(num_order) 
	and (base_conditions.call() or (ch("M8") and c.Data["Number"] == 12)))

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
							for id in range(1,player_count+1):
								if id == Turn:continue
								id -= 1
								GM.deal_cards(id,1)
						else:
							stack_combo(5)
					3: back_move("M13")
	
	match c.Data["Number"]:
		5: if ch("M4"):change_rotation_direct()
		10:
			if ch("M15").has(true):shift_turn()
			if ch("M15")[1]:
				wait_count = 0
				GM.set_Deal_Stack_Number(false,1)
				clear_conditions()
		12:
			if ch("M14")[0]:shift_turn()
		11:set_order_state(num_order,"Numbers")
		14:set_order_state(Choice_color,"Colors")
	
	
	if not ch("M3") and (c.Data["Number"] in [2,3,4] or 
		(c.Data["Number"] == 13 and c.Data["Color"] == 1)):
		Throw_conditions.append(nope)
	end_check(c)

var ifend=0
func end_check(c):
	if ( (c.Data["Number"] != 14 and Turn == Order["Colors"][0]) or 
		 (ch("M5") and c.Data["Number"] != 14) ) and Throw_conditions.has(Choice_color):
		Order["Colors"][1] = 0
		GM.table.get_node("Order_info").set_label("",0)
		Throw_conditions.erase(Choice_color)
		if not Throw_conditions.has(base_conditions):Throw_conditions.append(base_conditions)
	if c.Data["Number"] != 11 and Turn == Order["Numbers"][0] and Throw_conditions.has(num_order):
		Order["Numbers"][1] = 0
		GM.table.get_node("Order_info").set_label("",0)
		Throw_conditions.erase(num_order)
		if not Throw_conditions.has(base_conditions):Throw_conditions.append(base_conditions)
		
	if first_card:
		first_card = false
	elif GM.Players[Turn-1][0].On_Hand.size() == 0 and GM.Players[Turn-1][1] != -PI:
		GM.Players[Turn-1][1] = -PI
		ifend+=1
	
	Active_card = c
	if ch("M6"):
		if ifend == player_count-1:
			get_tree().quit()
	else:
		if ifend == 1:
			get_tree().quit()

func Get_from_Stack(id):
	if wait_count >= 0:
		GM.deal_cards(id,GM.game_rule["Deal_Stack_Cards"])
	
	# 4 - karta stop
	GM.Players[Turn-1][1] = wait_count
	wait_count = 0
	
	GM.set_Deal_Stack_Number(false,1)
	GM.table.get_node("Order_info").set_label2("",wait_count)
	#Dobieranie do skutku
	if (ch("M2") and Order["Colors"][1]==0 and Order["Numbers"][1]==0 and 
		not Throw_conditions.has(getter) and not Throw_conditions.has(stopper)):
		shift_turn()
	
	clear_conditions()
	Next_Turn()

func after_take_every_card(c:Array) -> bool:
	return false#usunac jak bedzie zrobione
	#brakuje aby gracz mogl zagrac ta karte jesli legalna #GM.Actor_play()
	#do powyzszego uwarzac bo makao zatrzymac sie moze na 169 linijce bo tam wywoluje sie after_take_every_card()
	#brakuje aby dalo sie rzucic tylko ta jedna
	#brakuje aby dalo sie odmowic, nie biorac wiecej kart! jesli nie trzeba dobierac do skutku
	#przy dobieraniu do skutku "M2" zawsze dobiera sie jedna, obslurzyc aby sie nie psulo
	#moze shift_turn()???
	if c.size()==1:
		return Legality_Check(c[0])
	return false

func clear_conditions():
	Throw_conditions.erase(getter)
	Throw_conditions.erase(stopper)
	Throw_conditions.erase(nope)

func Legality_Check(c)->bool:
	card = c
	
	#przy spelnieniu warunku mazna rzucic nawet mimo puli z kart funkcyjnych
	if true_except_orders("M15",c,10):	return true
	if true_except_orders("M14",c,12):	return true
	
	#warunek zakazujacy kart funkcyjnych na Asa
	if (ch("M16")[1] and Throw_conditions.has(Choice_color)
	 and (c.Data["Number"] in [2,3,4] or (c.Data["Number"] == 13 and c.Data["Color"] in [1,2]))): return false
	
	#warunki :dama na wszystko/wszystko na dame
	if Active_card.Data["Number"] == 12 and ch("M9"):	return true
	if (card.Data["Number"] == 12 and GM.game_rule["Deal_Stack_Cards"]==1 
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
