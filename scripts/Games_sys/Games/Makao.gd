extends just_throw
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
var first_card = true #zabezpieczenie przy rozpoczeciu gry

var first_save = [false,false,true] #pierwsza karta dobrana ze stosu mozna rzucic ale nie trzeba
var Report_Makao = [] 
var makao_range = [1]
var have_normal_card = false

func _init() -> void:
	Order_choice_list = {
	"Colors":["clear","Pik","Kier","Trefl","Karo"],
	"Numbers":["clear","5","6","7","8","9","10","Q"]
	}
	GM.Deck_size["count_colors"] = 4
	GM.Deck_size["count_numer"] = 13
	GM.Deck_size["count_jockers"] = 0
	GM.game_rule["Start_Cards"] = 4#dac mozliwosc dostosowania
	GM.game_rule["Deal_Stack_Cards"] = 1
	Throw_conditions.append(base_conditions)
	Order["Colors"] = [0,0] # pierwsza jest tura urzycia a 2 rzadana wartosc
	Order["Numbers"] = [0,0]

func Enemy_SI(xx):
	if xx.Data["Number"]==11:
		GM.Game.Obj_Order["Numbers"].get_children()[0].click()
	if xx.Data["Number"]==14:
		GM.Game.Obj_Order["Colors"].get_children()[0].click()

func Start_Player_Turn(numer,Hand):
	if ch("M10").has(true):
		Report_Makao[numer] = false
	
	if ch("M19"):
		for c in Hand:
			if (c.Data["Number"] in [5,6,7,8,9,10,12]) and c.legality:
				have_normal_card = true
				return
		have_normal_card = false

func End_Player_Turn(numer,Hand):
	if (Hand.size() not in makao_range):
		if Report_Makao[numer]: GM.Players[numer][0].set_info_color(Color(0.3,0.3,0.3))
		else:
			Report_Makao[numer] = true

func Can_from_Stack() -> bool:
	return (Turn == 0 and ( not ch("M19") or not have_normal_card))

func Knock_Knock(num=0):# Wcisniecie przycisku "Knock"
	if ch("M10").has(true): 
		if not Report_Makao[num]: 
			GM.Players[num][0].set_info_color(Color.RED)
			Report_Makao[num] = true
		for id in range(0,player_count):
			if not Report_Makao[id] and num != id:
				GM.deal_cards(id,GM.game_rule["Makao_miss_punishment"])
				Report_Makao[id] = true
				GM.Players[id][0].set_info_color(Color(0.3,0.3,0.3))

func set_game():
	Who_Starts_game()
	change_rotation_direct()
	GM.shuffle()
	var one = GM.send(1)
	Active_card = one[0]
	The_Deal()
	GM.table.Cards_is_Used(one)
	
	Next_Turn()

func The_Deal():
	GM.shuffle()
	for i in range(0,player_count):
		GM.deal_cards(i,GM.game_rule["Start_Cards"])

func config_character2(Data):
	player_count = get_value(0,Data)
	for i in player_count:
		Report_Makao.append(true)
		
	GM.Deck_size["count_decks"] = get_value(1,Data)
	GM.game_rule["Start_Cards"] = get_value(2,Data)
	GM.game_rule["Makao_miss_punishment"] = get_value(3,Data)
	
	if ch("M10")[1]: makao_range.append(0)

func get_choise(Order_value,Order_type):
	if Order.has(Order_type):
		Order[Order_type] = [Turn,Order_value]
		GM.table.get_node("Order_info").set_label(Order_type,Order_value)
		sig_to_con.emit()
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

func set_order_state(ord,order_type):
	if Order[order_type][1] == 0:
		Throw_conditions.erase(ord)
		if not Throw_conditions.has(base_conditions):Throw_conditions.append(base_conditions)
	elif not Throw_conditions.has(ord):
		Throw_conditions.append(ord)
		Throw_conditions.erase(base_conditions)

func true_except_orders(order_num,c,num:int):
	return (ch(order_num)[1] and c.Data["Number"] == num 
	and not Throw_conditions.has(Choice_color) and not Throw_conditions.has(num_order) 
	and (base_conditions.call() or (ch("M8") and c.Data["Number"] == 12)))

func stack_combo(vari):
	if GM.game_rule["Deal_Stack_Cards"]==1: GM.game_rule["Deal_Stack_Cards"]=0
	GM.set_Deal_Stack_Number(ch("M1"),vari)
	if not Throw_conditions.has(getter):
		Throw_conditions.append(getter)

var ifend=0
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
						if ch("M12"):back_move()
					2:
						if ch("M18"):
							for id in range(0,player_count):
								if (id) == Turn or GM.Players[id][1] == -PI:continue
								GM.deal_cards(id,1)
						else:
							stack_combo(5)
					3: if ch("M12"):back_move()
	
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
	
	#Koncowe sprawdzenie
	
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
	elif GM.Players[Turn][0].On_Hand.size() == 0 and GM.Players[Turn][1] != -PI:
		end_check()
	
	first_save[1] = false
	Active_card = c
	End_Game()

func end_check():
	GM.Players[Turn][1] = -PI
	ifend+=1
	GM.ranking.append([GM.Players[Turn][0],0])

func End_Game():
	if ch("M6"):
		if ifend == player_count-1:
			for p in GM.Players:
				if not GM.ranking.has(p):
					GM.ranking.append([p[0],p[0].On_Hand.size()])
					break
			SMen.change_scene("res://scens/Leader_Board.tscn")
	else:
		if ifend == 1:
			var xx = []
			for p in GM.Players:
				if GM.Players[Turn][0] == p[0]:continue
				xx.append([p[0],p[0].On_Hand.size()])
			xx.sort_custom(func(a, b): return a[1] < b[1])
			for p in xx:
				GM.ranking.append(p)
			SMen.change_scene("res://scens/Leader_Board.tscn")

func Get_from_Stack(id):
	GM.send(0)
	if wait_count >= 0 and not first_save[1]:
		
		GM.Players[id][0].set_info_color(Color(0.3,0.3,0.3))
		Report_Makao[id] = true
		
		GM.deal_cards(id,GM.game_rule["Deal_Stack_Cards"],first_save[2])
	
	if first_save[0]:# wywolane po dobraniu pierwszej karty jesli mozna ja legalnie rzucic
		first_save[0] = false
		first_save[1] = true#jesli nie trzeba dobierac do skutku to na tej karcie sie konczy
		if ch("M2"):
			first_save[1] = false
		if Throw_conditions.has(getter):
			if GM.game_rule["Deal_Stack_Cards"] >= 1: GM.game_rule["Deal_Stack_Cards"] -= 1
			first_save[1] = false
			first_save[2] = false
		shift_turn()
		Next_Turn()
	else:
		first_save[1] = false
		first_save[2] = true
		# 4 - karta stop
		GM.Players[Turn][1] = wait_count
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
	if first_card: Active_card = c[0]
	if c.size()==1 and (ch("M7").has(true)) and not ch("M2") and Legality_Check(c[0]):
		first_save[0] = true
		return true
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

func Can_Hold_bool()->bool:
	return (not ch("M11") or (not ch("M7")[1] and first_save[1]))

func Can_Hold_when(Hold_card,c)->bool:
	return (Hold_card.Data["Number"] == c.Data["Number"])
