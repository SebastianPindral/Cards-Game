extends Node
class_name Makao

func Throw_card(c):
	if c.Data["Number"] == 2 or c.Data["Number"] == 3:
		GM.game_rule["Deal_Stack_Cards"] += c.Data["Number"]

func Get_from_Stack():
	GM.game_rule["Deal_Stack_Cards"] = 1
