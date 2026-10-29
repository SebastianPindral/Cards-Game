extends BGM

func Start_Game(t):
	table = t
	change_rotation_direct()
	Next_Turn()
	set_game()

func Deal_Stack_Cards(id):
	deal_cards(id,game_rule["Deal_Stack_Cards"])
	Next_Turn()

func card_function(card):
	Active_card = card

func throw_card(card) -> bool:
	if (Active_card.Data["Number"] == card.Data["Number"]
	or Active_card.Data["Color"] == card.Data["Color"]):
		table.Cards_is_Used([card])
		Next_Turn()
		return true
	else: return false
