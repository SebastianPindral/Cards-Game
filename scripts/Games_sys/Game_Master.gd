extends BGM

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
	Active_card = c

func throw_card(c:Array):
	if c.size()>0:await Game.Before_Throw(c[-1])
	table.Cards_is_Used(c)
	SMen.reorder_Stack(Discarded)
	Game.After_Turn()
