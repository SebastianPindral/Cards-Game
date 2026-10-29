extends BaseGame
class_name Makao
var getter = func() -> bool: return (GM.card.Data["Number"] == 2 or GM.card.Data["Number"] == 3)
var stopper = func() -> bool: return GM.card.Data["Number"] == 4

var wait_count = 0
func Throw_card(c):
	if c.Data["Number"] == 2 or c.Data["Number"] == 3:
		if GM.game_rule["Deal_Stack_Cards"]==1: GM.game_rule["Deal_Stack_Cards"]=0
		GM.set_Deal_Stack_Number(characteristics["M1"],c.Data["Number"])
		if not GM.Throw_conditions.has(getter):
			GM.Throw_conditions.append(getter)
	elif c.Data["Number"] == 4:
		if characteristics["M1"] or wait_count == 0:
			wait_count -= 1
		if not GM.Throw_conditions.has(stopper):
			GM.Throw_conditions.append(stopper)
	elif c.Data["Number"] == 5 and characteristics["M4"]:
		GM.change_rotation_direct()

func Get_from_Stack():
	GM.set_Deal_Stack_Number(false,1)
	GM.Players[GM.Turn-1][1] = wait_count
	wait_count = 0
	GM.Throw_conditions.erase(getter)
	GM.Throw_conditions.erase(stopper)
