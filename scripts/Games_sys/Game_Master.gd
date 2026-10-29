extends BGM

var Game

func Start_Game(t):
	table = t
	change_rotation_direct()
	set_game()
	Next_Turn()

func new_game(game_type):
	match game_type:
		"Makao":	Game = Makao.new()
		_:
			print("Blad wczytania gry")
			get_tree().quit()

func Deal_Stack_Cards(id):
	send(0)
	Game.Get_from_Stack(id)
	Next_Turn()

func card_function(c):#obslurzyc karty funkcyjne
	Game.Throw_card(c)
	Active_card = c

func throw_card(c:Array):
	table.Cards_is_Used(c)
	SMen.reorder_Stack(Discarded)
	Next_Turn()
