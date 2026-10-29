extends Node
signal Stack_number(arg)

var table #wskaznik na stol
var Players = []
var Deck_size = {"count_colors":4,"count_numer":13,"count_decks":1,"count_jockers":0}
var Dis_poz = Vector2(900,450) #Srodek stolu
var player_count = 4

var game_rule = {"Start_Cards":5,"Deal_Stack_Cards":1}
func set_Deal_Stack_Number(adding,vari):
	if adding:	game_rule["Deal_Stack_Cards"] += vari
	else:		game_rule["Deal_Stack_Cards"] = vari
	Stack_number.emit(game_rule["Deal_Stack_Cards"])

var Stack = []
var Discarded = [] # zuzyte karty

func send(i):
	var t = []
	for x in range(min(i, Stack.size()) - 1, -1, -1):
		t.append(Stack[x])
		Stack.remove_at(x)
		if Game.after_take_every_card(t): break #dokonczyc priorytetowo!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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

func shuffle():
	if Stack.size()>1:
		Stack.shuffle()
		SMen.reorder_Stack(Stack)
		table.stack.Set_Stack(Stack)

#dla uruchomienia i funkcji gry
var Game

func Start_Game(t):
	table = t
	Game.set_game(player_count)

func new_game(game_type):
	match game_type:
		"Makao":	Game = Makao.new()
		_:
			print("Blad wczytania gry")
			get_tree().quit()

func Deal_Stack_Cards(id):
	send(0)
	Game.Get_from_Stack(id)

func card_function(c):#obslurzyc karty funkcyjne
	Game.Throw_card(c)

func throw_card(c:Array):
	if c.size()>0:await Game.Before_Throw(c[-1])
	table.Cards_is_Used(c)
	SMen.reorder_Stack(Discarded)
	Game.After_Turn()
