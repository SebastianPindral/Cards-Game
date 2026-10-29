extends trick_taking
class_name Kierki
var starter = func() -> bool:  return (card.Data["Number"] == 2 and card.Data["Color"] == 3)

var card_exchange = true # tura wymiany kart

func Who_Starts_game(): # zaczyna 2 trefl
	Set_Turn(Who_have_card(3,2))

func permission_to_throw() -> bool: # wymog rzucenia konkretnie 3 kart na koczatku petli
	if (not card_exchange or GM.Players[Turn][0].On_Hold.size() == 3):return true
	else: return false
