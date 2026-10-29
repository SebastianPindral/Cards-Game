extends BaseGame
class_name Makao
var base_conditions = func() -> bool: return (GM.Active_card.Data["Number"] == GM.card.Data["Number"] 
											or GM.Active_card.Data["Color"] == GM.card.Data["Color"])
var getter = func() -> bool: 
	return (GM.card.Data["Number"] in [2,3] or (GM.card.Data["Number"] == 13 and (GM.card.Data["Color"] in [1,2])))

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
	Throw_conditions.append(base_conditions)
	Order["Colors"] = [0,0] # pierwsza jest tura urzycia a 2 rzadana wartosc
	Order["Numbers"] = [0,0]

func set_choise_obj(Order_obj,Order_type):
	Obj_Order[Order_type] = Order_obj

func get_choise(Order_value,Order_type):
	if Order.has(Order_type):
		Order[Order_type] = [GM.Turn,Order_value]
		print(Order_type," : ",Order[Order_type])
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

func Throw_card(c):
	if c.Data["Number"] in [2,3]:
		if GM.game_rule["Deal_Stack_Cards"]==1: GM.game_rule["Deal_Stack_Cards"]=0
		GM.set_Deal_Stack_Number(characteristics["M1"],c.Data["Number"])
		if not Throw_conditions.has(getter):
			Throw_conditions.append(getter)
	elif c.Data["Number"] == 4:
		if characteristics["M1"] or wait_count == 0:
			wait_count -= 1
		if not Throw_conditions.has(stopper):
			Throw_conditions.append(stopper)
	elif c.Data["Number"] == 5 and characteristics["M4"]:
		GM.change_rotation_direct()
	elif c.Data["Number"] == 13 and (c.Data["Color"] == 1 or c.Data["Color"] == 2):#K
		if GM.game_rule["Deal_Stack_Cards"]==1: GM.game_rule["Deal_Stack_Cards"]=0
		GM.set_Deal_Stack_Number(characteristics["M1"],5)
		if c.Data["Color"] == 1 and characteristics["M12"]:
			GM.Turn_move(2,not GM.Rotation_direct)
		elif c.Data["Color"] == 3 and characteristics["M13"]:
			GM.Turn_move(2,not GM.Rotation_direct)
		if not Throw_conditions.has(getter):
			Throw_conditions.append(getter)
	elif c.Data["Number"] == 10 and characteristics["M15"]:#Shift 10
		GM.Turn_move(1,not GM.Rotation_direct)
	elif c.Data["Number"] == 12 and characteristics["M14"]:#Shift Q
		GM.Turn_move(1,not GM.Rotation_direct)
	elif c.Data["Number"] == 11:#J
		if Order["Numbers"][1] == 0:
			Throw_conditions.erase(num_order)
		elif not Throw_conditions.has(num_order):
			Throw_conditions.append(num_order)
			Throw_conditions.erase(base_conditions)
			print("J")
	elif c.Data["Number"] == 14:#A
		if Order["Colors"][1] == 0:
			Throw_conditions.erase(Choice_color)
		elif not Throw_conditions.has(Choice_color):
			Throw_conditions.append(Choice_color)
			Throw_conditions.erase(base_conditions)
			print("A")
	
	if not characteristics["M3"] and (c.Data["Number"] in [2,3,4] or 
		(c.Data["Number"] == 13 and (c.Data["Color"] == 1 or c.Data["Color"] == 2))):
		Throw_conditions.append(nope)
	end_check(c)

var ifend=0
func end_check(c):
	if  c.Data["Number"] != 14 and GM.Turn == Order["Colors"][0] and Throw_conditions.has(Choice_color):
		Order["Colors"][1] = 0
		Throw_conditions.erase(Choice_color)
		if not Throw_conditions.has(base_conditions):Throw_conditions.append(base_conditions)
	if c.Data["Number"] != 11 and GM.Turn == Order["Numbers"][0] and Throw_conditions.has(num_order):
		Order["Numbers"][1] = 0
		Throw_conditions.erase(num_order)
		if not Throw_conditions.has(base_conditions):Throw_conditions.append(base_conditions)
		
	if first_card:
		first_card = false
	elif GM.Players[GM.Turn-1][0].On_Hand.size() == 0 and GM.Players[GM.Turn-1][1] != -PI:
		GM.Players[GM.Turn-1][1] = -PI
		ifend+=1
	
	if characteristics["M6"]:
		if ifend == GM.player_count-1:
			get_tree().quit()
	else:
		if ifend == 1:
			get_tree().quit()

func Get_from_Stack(id):
	if wait_count >= 0:
		GM.deal_cards(id,GM.game_rule["Deal_Stack_Cards"])
	GM.set_Deal_Stack_Number(false,1)
	
	# 4 - karta stop
	GM.Players[GM.Turn-1][1] = wait_count
	wait_count = 0
	
	#Dobieranie do skutku
	if (characteristics["M2"] and Order["Colors"][1]==0 and Order["Numbers"][1]==0 and 
		not Throw_conditions.has(getter) and not Throw_conditions.has(stopper)):
		GM.Turn_move(1,not GM.Rotation_direct)
	
	Throw_conditions.erase(getter)
	Throw_conditions.erase(stopper)
	Throw_conditions.erase(nope)

func Legality_Check(c)->bool:
	GM.card = c
	if GM.Active_card.Data["Number"] == 12 and characteristics["M9"]:	return true
	if (GM.card.Data["Number"] == 12 and GM.game_rule["Deal_Stack_Cards"]==1 
		and wait_count >= 0 and Order["Numbers"][1]==0 and characteristics["M8"]):	return true
	return SHelp.if_in_loop(Throw_conditions)

func Can_Hold(On_Hand,On_Hold):#oznacza nielegalnym karty nie pasujące do tych podniesionych
	if not characteristics["M11"]: 
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
