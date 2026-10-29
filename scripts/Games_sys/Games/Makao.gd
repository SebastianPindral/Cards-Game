extends BaseGame
class_name Makao
var getter = func() -> bool: return (GM.card.Data["Number"] == 2 or GM.card.Data["Number"] == 3)
var stopper = func() -> bool: return GM.card.Data["Number"] == 4

var wait_count = 0
var first_card = true
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
	
	end_check()

var ifend=0
func end_check():
	if first_card:
		first_card = false
	elif GM.Players[GM.Turn-1][0].On_Hand.size() == 0 and GM.Players[GM.Turn-1][1] != -PI:
		GM.Players[GM.Turn-1][1] = -PI
		ifend+=1
	
	if characteristics["M6"]:
		if ifend == GM.player_count-1:
			get_tree().quit()
	else:
		if ifend == 1:
			get_tree().quit()

func Get_from_Stack(id):
	if wait_count==0:
		GM.deal_cards(id,GM.game_rule["Deal_Stack_Cards"])
	GM.set_Deal_Stack_Number(false,1)
	GM.Players[GM.Turn-1][1] = wait_count
	wait_count = 0
	GM.Throw_conditions.erase(getter)
	GM.Throw_conditions.erase(stopper)
