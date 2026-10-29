extends just_throw
class_name Pan
var base_conditions = func() -> bool: return (Active_card.Data["Number"] <= card.Data["Number"])
var starter = func() -> bool:  return (card.Data["Number"] == 9 and card.Data["Color"] == 2)
var ifend=0

func _init() -> void:
	GM.Deck_size["count_colors"] = 4
	GM.Deck_size["count_numer"] = 6
	GM.Deck_size["count_jockers"] = 0
	GM.game_rule["Deal_Stack_Cards"] = -1
	
	Throw_conditions.append(starter)

func set_game():
	for p in GM.Players: #sortowanie rosnaco
		p[0].sort_style = false
	
	The_Deal()
	change_rotation_direct()
	Set_Turn(Who_have_card(2,9))
	shift_turn()
	Next_Turn()

func The_Deal():
	GM.shuffle()
	var card_count = GM.Stack.size()
	for i in range(0,player_count):
		GM.deal_cards(i,(card_count / player_count))

func config_character2(Data):
	player_count = get_value(0,Data)

func After_Turn():
	Next_Turn()

func Get_from_Stack(id):pass

func Before_Throw(_c):
	if not Throw_conditions.has(base_conditions):
		Throw_conditions.append(base_conditions)
		Throw_conditions.erase(starter)

func Throw_card(c):
	if ch("M1") and c.Data["Color"] == 1:
		back_move()
	
	Active_card = c
	#-----------------------------------------------
	if GM.Players[Turn][0].On_Hand.size() == 0 and GM.Players[Turn][1] != -PI:
		end_check()
	
	End_Game()


func Can_Hold_bool()->bool:
	return not ch("M2").has(true)

func Can_Hold_when(Hold_card,c)->bool:
	return (Hold_card.Data["Number"] == c.Data["Number"])

func Legality_Check(c)->bool:
	card = c
	
	return SHelp.if_in_loop(Throw_conditions)

func end_check():
	GM.Players[Turn][1] = -PI
	ifend+=1
	GM.ranking.append([GM.Players[Turn][0],0])

func End_Game():
	if ifend == player_count-1:
		for p in GM.Players:
			if not GM.ranking.has(p):
				GM.ranking.append([p[0],p[0].On_Hand.size()])
				break
		SMen.change_scene("res://scens/Leader_Board.tscn")
