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

func Legality_Check(c)->bool:
	card = c
	return SHelp.if_in_loop(Throw_conditions)

func Can_Hold(On_Hand,On_Hold):#oznacza nielegalnym karty nie pasujące do tych podniesionych
	for c in On_Hand:
		c.legal(Legality_Check(c))
		if not Legality_Check(On_Hold[0]):
			for Hold_card in On_Hold:
				Hold_card.reset(Legality_Check(Hold_card))
			On_Hold.clear()
			return
		for Hold_card in On_Hold:
			if Hold_card.Data["Number"] == c.Data["Number"]:
				c.legal(true)
				break
			c.legal(false)
