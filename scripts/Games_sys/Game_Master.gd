extends BGM

func Start_Game(t):
	table = t
	change_rotation_direct()
	set_game()
	Next_Turn()

func Deal_Stack_Cards(id):
	send(0)
	deal_cards(id,game_rule["Deal_Stack_Cards"])
	Next_Turn()

func card_function(card):#obslurzyc karty funkcyjne
	Active_card = card

func throw_card(card):
	table.Cards_is_Used(card)
	SMen.reorder_Stack(Discarded)
	Next_Turn()

func Legality_Check(card)->bool:
	if (Active_card.Data["Number"] == card.Data["Number"] or Active_card.Data["Color"] == card.Data["Color"]):
		return true
	else: return false

func Can_Hold(On_Hand,On_Hold):#oznacza nielegalnym karty nie pasujące do tych podniesionych
	for card in On_Hand:
		card.legal(Legality_Check(card))
		for Hold_card in On_Hold:
			if Hold_card.Data["Number"] == card.Data["Number"]:
				card.legal(true)
				break
			card.legal(false)
