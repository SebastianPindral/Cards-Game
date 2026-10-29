extends Node
class_name BGM
signal Stack_number(arg)

var table #wskaznik na stol
var Players = []
var Deck_size = {"count_colors":4,"count_numer":13,"count_decks":1,"count_jockers":0}
var Dis_poz = Vector2(900,450) #Srodek stolu
var player_count = 4
var Turn = 0 # false jesli gracz nie moze nic robic
var Rotation_direct = true

var game_rule = {"Start_Cards":5,"Deal_Stack_Cards":1}
func set_Deal_Stack_Number(adding,vari):
	if adding:	game_rule["Deal_Stack_Cards"] += vari
	else:		game_rule["Deal_Stack_Cards"] = vari
	Stack_number.emit(game_rule["Deal_Stack_Cards"])

var Stack = []
var Discarded = [] # zuzyte karty
var Active_card # karta na szczycie stosu
var card #aktualnie testowana karta
var last_take_card#ostatnia karta dobrane ze stosu

func send(i):
	var t = []
	for x in range(min(i, Stack.size()) - 1, -1, -1):
		t.append(Stack[x])
		Stack.remove_at(x)
	if game_rule["Deal_Stack_Cards"] >= Stack.size():
		Reset_Stack(1)
	return t

func Reset_Stack(left_on_discard):
	for card_of_dis in range(Discarded.size()-left_on_discard-1,-1,-1):
		Stack.append(Discarded[card_of_dis])
		Discarded.remove_at(card_of_dis)
	shuffle()

func Player_count():	return player_count
func deal_cards(pid,count):	Players[pid][0].take_cards(send(count))
func Actor_poz(index):	return Players[index-1][0].global_position
func Actor_play(index):	Players[index-1][0].play()

func change_rotation_direct():
	Rotation_direct = not Rotation_direct
	table.spin.Re_Direct()

func shuffle():
	if Stack.size()>1:
		Stack.shuffle()
		SMen.reorder_Stack(Stack)
		table.stack.Set_Stack(Stack)

func Turn_move(value,RD_Local):
	for x in value:
		if not RD_Local:
			if Turn < player_count:
				Turn += 1
			else: Turn = 1
		else:
			if Turn > 1:
				Turn -= 1
			else: Turn = player_count

func Get_Turn(value,RD_Local) -> int:
	var local_turn = Turn
	for x in value:
		if not RD_Local:
			if local_turn < player_count:
				local_turn += 1
			else: local_turn = 1
		else:
			if local_turn > 1:
				local_turn -= 1
			else: local_turn = player_count
	return local_turn

func Next_Turn():
	if Players[Turn-1][1] > 0:# jest wiekszy od zera jesli gracz ma wykonac wiecej jak jedna ture
		Players[Turn-1][1] -= 1
	else:
		Turn_move(1,Rotation_direct)
	table.cursor.set_cursor_target(Turn)
	
	if Players[Turn-1][1] == -PI:
		Next_Turn()
	elif Players[Turn-1][1] < 0: # jest mniejszy od zera jesli gracz musi czekac i nic nie robic
		Players[Turn-1][1] += 1
		Stack_number.emit(game_rule["Deal_Stack_Cards"])
		Next_Turn()
	elif Players[Turn-1][1] == 0:
		Actor_play(Turn)

func throw_card(_card):pass
func card_function(_card):pass
func Deal_Stack_Cards(_id):pass
