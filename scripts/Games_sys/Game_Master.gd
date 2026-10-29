extends Node
signal Stack_number(arg)
signal players()

var table #wskaznik na stol
var score_board #tablica wynikow w UI
var Players = []
var Deck_size = {"count_colors":4,"count_numer":13,"count_decks":1,"count_jockers":0}
var Dis_poz = Vector2(900,450) #Srodek stolu

var game_rule = {"Start_Cards":5,"Deal_Stack_Cards":-1}
func set_Deal_Stack_Number(adding,vari):
	if adding:	game_rule["Deal_Stack_Cards"] += vari
	else:		game_rule["Deal_Stack_Cards"] = vari
	Stack_number.emit(game_rule["Deal_Stack_Cards"])

var Stack = []
var Discarded = [] # zuzyte karty

var ranking = []

func send(i,breaking = false,front_back = false):
	var t = []
	var for_direct
	if front_back:
		for_direct = range(0, min(i, Stack.size())) #od poczatku stosu (najstarsze)
	else:
		for_direct = range(Stack.size() - 1, max(Stack.size() - 1 - i, -1), -1) #od konca stosu (najnowsze)
	
	for x in for_direct:
		t.append(Stack[x])
		Stack.remove_at(x)
		if breaking and Game.after_take_every_card(t): break
	if game_rule["Deal_Stack_Cards"] >= Stack.size():
		Reset_Stack(1)
	return t

func send_from_disc(i = Discarded.size(),left_on_discard:int = 0,front_back:bool = false):
	var t = []
	var for_direct
	if front_back:
		for_direct = range(0, min(i, max(Discarded.size() - left_on_discard, 0))) #od poczatku stosu (najstarsze)
	else:
		for_direct = range(Discarded.size() - 1, max(Discarded.size() - 1 - i, left_on_discard - 1), -1) #od konca stosu (najnowsze)
	
	for card_of_dis in for_direct:
		t.append(Discarded[card_of_dis])
		Discarded.remove_at(card_of_dis)
	return t

func Reset_Stack(left_on_discard:int = 0):
	Stack.append_array(send_from_disc(Discarded.size(),left_on_discard,true))
	shuffle()

func Player_count():	return Game.player_count
func deal_cards(pid,count,breaking0 = false,front_back0 = false):
	Players[pid][0].take_cards(send(count,breaking0,front_back0))

func deal_disc_cards(pid,count,left_on_discard0,front_back0 = false):
	Players[pid][0].take_cards(send_from_disc(count,left_on_discard0,front_back0))

func Actor_poz(index):	return Players[index][0].global_position
func Actor_play(index):	Players[index][0].play()

func shuffle():
	if Stack.size()>1:
		Stack.shuffle()
		SMen.reorder_Stack(Stack)
		table.stack.Set_Stack(Stack)

#dla uruchomienia i funkcji gry
var Game

func Start_Game(t):
	table = t
	Game.set_game()

func new_game(game_type):
	match game_type:
		"Makao":	Game = Makao.new()
		"Spades":	Game = Spades.new()
		"Pan":		Game = Pan.new()
		"Sapers":	Game = Sapers.new()
		_:
			print("Blad wczytania gry")
			get_tree().quit()

func Deal_Stack_Cards(id):
	Game.Get_from_Stack(id)

func card_function(c):#obslurzyc karty funkcyjne
	Game.Throw_card(c)

func throw_card(c:Array):
	if c.size()>0:await Game.Before_Throw(c[-1])
	table.Cards_is_Used(c)
	SMen.reorder_Stack(Discarded)
	Game.After_Turn()

func void0():
	players.emit()
