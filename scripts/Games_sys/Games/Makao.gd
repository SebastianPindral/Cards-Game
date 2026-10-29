extends Node
class_name Makao
var getter = func() -> bool: return (GM.card.Data["Number"] == 2 or GM.card.Data["Number"] == 3)
var stopper = func() -> bool: return GM.card.Data["Number"] == 4

func Throw_card(c):
	if c.Data["Number"] == 2 or c.Data["Number"] == 3:
		if GM.game_rule["Deal_Stack_Cards"]==1: GM.game_rule["Deal_Stack_Cards"]=0
		GM.set_Deal_Stack_Number(true,c.Data["Number"])
		if not GM.Throw_conditions.has(getter):
			GM.Throw_conditions.append(getter)
	elif c.Data["Number"] == 4:
		#dodaj tresc
		if not GM.Throw_conditions.has(stopper):
			pass#GM.Throw_conditions.append(stopper)

func Get_from_Stack():
	GM.set_Deal_Stack_Number(false,1)
	GM.Throw_conditions.erase(getter)
