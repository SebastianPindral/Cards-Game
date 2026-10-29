extends BGM

func Start_Game(t):
	table = t
	change_rotation_direct()
	set_game()
	Next_Turn()

func Deal_Stack_Cards(id):
	deal_cards(id,game_rule["Deal_Stack_Cards"])
	Next_Turn()

func card_function(card):
	Active_card = card

func throw_card(card) -> bool:
	if Legality_Check(card):
		table.Cards_is_Used([card])
		SMen.reorder_Stack(Discarded)
		Next_Turn()
		return true
	else: return false

func Legality_Check(card)->bool:
	if (Active_card.Data["Number"] == card.Data["Number"] or Active_card.Data["Color"] == card.Data["Color"]):
		return true
	else: return false
