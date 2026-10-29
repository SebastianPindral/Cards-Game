extends Node
class_name BaseGame
signal sig_to_con()#sygnal wybrania warunku
#konfiguracja gry
var characteristics = {}
var Order_choice_list #kolo wyboru

# nieokreslona ilosc warunkow do spelnienia aby rzucic karta
var Throw_conditions = []
#rzadanie liczby lub coloru
var Obj_Order = {}
var Order = {}

var auction = {}
var full_score = {}
var auction_var = 0
var auction_bool = true

var player_count
var Turn = 0
var Rotation_direct = true

var Active_card # karta na szczycie stosu
var card #aktualnie testowana karta

var was_emited = false
func catch_signal():
	if was_emited: 
		was_emited = false
		return
	was_emited = false
	await sig_to_con

func throw_signal():
	was_emited = true
	sig_to_con.emit()

func Who_have_card(color,number):
	var i = 0
	for p in GM.Players:
		for c in p[0].On_Hand:
			if c.Data["Color"] == color and c.Data["Number"] == number:
				return i
		i+=1
	return 0

func Who_Starts_game():
	Turn = randi_range(0,player_count-1)

func characteristic(text,state):	characteristics[text] = state #zapisywanie ustawien

func config_character(Data): #wywolane po zaakceptowaniu ustawien
	var value
	for x in Data:
		if x == "OCL_name_list":continue
		if Data[x][1] is not bool:
			if Data[x][1] == 1:	value = [true,false]
			elif Data[x][1] == 0:	value = [false,false]
			elif Data[x][1] == 2:	value = [false,true]
		else:
			value = Data[x][1]
		characteristic(Data[x][0],value)
	config_character2(Data)

func config_character2(_Data):pass

func get_value(index,Data): return Data["OCL_name_list"][index][2][Data["OCL_name_list"][index][1]]

func ch(text): 
	if characteristics.has(text):
		return characteristics[text]
	else: return false

func The_Deal():pass

func Legality_Check(_card)->bool:return false

func Can_Hold_bool()->bool:return true # czy w ogule mozna podnosic wiecej kart i dlaczego
func Can_Hold_when(_Hold_card,_c)->bool:return false # pod jakim warunkiem karta moze byc podnieciona

func Can_Hold(On_Hand,On_Hold):#oznacza nielegalnym karty nie pasujące do tych podniesionych
	if Can_Hold_bool():
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
			if Can_Hold_when(Hold_card,c):
				c.legal(true)
				break
			c.legal(false)

func set_choise_obj(Order_obj,Order_type):	Obj_Order[Order_type] = Order_obj
func get_choise(_Order_value,_Order_type):pass # odebranie warunku z kola wyboru
func set_game(): pass #wywolane po uruchomieniu gry
func Before_Throw(_c): pass
func After_Turn():pass
func Throw_card(_c): pass
func Get_from_Stack(_id):pass

func Enemy_SI(_xx):pass

func set_poz_on_discard(_c,_dis_poz):pass 

func permission_to_throw() -> bool:return true #pozwala na zablokowanie rzutu jesli np jest wymog rzucenia 1 lub 4 kart a jest zaznaczonych 2 lub 3
func after_take_every_card(_c:Array) -> bool:return false #warunek przerwania pobierania przy kilku kartach na raz
func Can_from_Stack() -> bool:return false

func Start_Player_Turn(_numer,_Hand):pass
func End_Player_Turn(_numer,_Hand):pass

func Knock_Knock(_num = null):pass

func end_check():pass #wywolane po kazdym ruchu ktory zmienia ranking
func End_Game():pass #Wywolane kiedy gra sie konczy

func change_rotation_direct():
	Rotation_direct = not Rotation_direct
	GM.table.spin.Re_Direct()

func Turn_move(value):
	var u_value = range(abs(value))
	var rot_dir = (not Rotation_direct) if value < 0 else (Rotation_direct)
	for x in u_value:
		if not rot_dir:
			if Turn < player_count-1:
				Turn += 1
			else: Turn = 0
		else:
			if Turn > 0:
				Turn -= 1
			else: Turn = player_count-1
		if GM.Players[Turn][1] == -PI:
			u_value.append(0)

func Get_Turn(value,local) -> int:
	var local_turn = local
	var u_value = abs(value)
	var rot_dir = (not Rotation_direct) if value < 0 else (Rotation_direct)
	for x in u_value:
		if not rot_dir:
			if local_turn < player_count-1:
				local_turn += 1
			else: local_turn = 0
		else:
			if local_turn > 0:
				local_turn -= 1
			else: local_turn = player_count-1
	return local_turn

func back_move():	Turn_move(-2)
func shift_turn():	Turn_move(-1)

func Set_Turn(i):
	if typeof(i) == TYPE_INT:
		Turn = i

func Next_Turn():
	if GM.Players[Turn][1] > 0:# jest wiekszy od zera jesli gracz ma wykonac wiecej jak jedna ture
		GM.Players[Turn][1] -= 1 
	else:
		Turn_move(1)
	GM.table.cursor.set_cursor_target(Turn)
	
	var ptc = GM.Players[Turn][1]
	if ptc == -PI:
		Next_Turn()
	elif ptc < 0: # jest mniejszy od zera jesli gracz musi czekac i nic nie robic
		GM.Players[Turn][1] += 1
		GM.Stack_number.emit(GM.game_rule["Deal_Stack_Cards"])
		Next_Turn()
	elif ptc == 0:
		GM.Actor_play(Turn)
