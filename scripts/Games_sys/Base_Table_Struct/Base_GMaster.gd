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


# nieokreslona ilosc warunkow do spelnienia aby rzucic karta
var Throw_conditions = [func() -> bool: return (Active_card.Data["Number"] == card.Data["Number"] 
						or Active_card.Data["Color"] == card.Data["Color"])]

var Stack = []
var Discarded = [] # zuzyte karty
var Active_card # karta na szczycie stosu
var card #aktualnie testowana karta

func set_game():
	shuffle()
	table.Cards_is_Used(send(1))
	for i in range(0,player_count):
		deal_cards(i,game_rule["Start_Cards"])

func send(i):
	var t = []
	for x in range(min(i, Stack.size()) - 1, -1, -1):
		t.append(Stack[x])
		Stack.remove_at(x)
	if game_rule["Deal_Stack_Cards"] >= Stack.size():
		for card_of_dis in range(Discarded.size()-2,-1,-1):
			Stack.append(Discarded[card_of_dis])
			Discarded.remove_at(card_of_dis)
		shuffle()
	return t

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

func Next_Turn():
	if Players[Turn-1][1] > 0:# jest wiekszy od zera jesli gracz ma wykonac wiecej jak jedna ture
		Players[Turn-1][1] -= 1
	else:
		if not Rotation_direct:
			if Turn < player_count:
				Turn += 1
			else: Turn = 1
		else:
			if Turn > 1:
				Turn -= 1
			else: Turn = player_count
	table.cursor.set_cursor_target(Turn)
	
	if Players[Turn-1][1] == -PI:
		Next_Turn()
	elif Players[Turn-1][1] < 0: # jest mniejszy od zera jesli gracz musi czekac i nic nie robic
		Players[Turn-1][1] += 1
		Next_Turn()
	elif Players[Turn-1][1] == 0:
		Actor_play(Turn)

func Legality_Check(_card)->bool:return false
func throw_card(_card):pass
func card_function(_card):pass
func Deal_Stack_Cards(_id):pass
