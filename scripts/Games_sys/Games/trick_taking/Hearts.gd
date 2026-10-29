extends trick_taking
class_name Hearts
var starter = func() -> bool:  return (card.Data["Number"] == 2 and card.Data["Color"] == 3)

var card_exchange = false # tura wymiany kart

var Hearts_count = {"End var":0}

var start_loop = true
func get_value(index,Data): return Data["OCL_name_list"][index][2][Data["OCL_name_list"][index][1]]

func config_character2(Data):
	Order_choice_list = {"Numbers":["0"]} # do usuniecia
	player_count = get_value(0,Data)
	Hearts_count["End var"] = get_value(1,Data) # do ilu sie gra
	Turn = player_count-1
	Atut = -1 
	color_blocked = 2
	for i in range(player_count):
		full_score[i] = [0,0] # 0-wynik , 1- overflow
		auction[i] = [0,0] #pierwsze na punkty dodatnie a drugie na ujemne (potrzebne dla J-Karo -10)

func Who_Starts_game(): # zaczyna 2 trefl
	Set_Turn(Who_have_card(3,2))
	shift_turn()

func permission_to_throw() -> bool: # wymog rzucenia konkretnie 3 kart na poczatku petli
	if (not card_exchange or GM.Players[Turn][0].On_Hold.size() == 3):return true
	else: return false

func Start_loop_card():
	if start_loop:
		Throw_conditions.append(starter)
		start_loop = false
# ------------- AUCTION --------------------
func Enemy_SI(xx):
	if typeof(xx) is int:
		GM.Game.Obj_Order["Numbers"].get_children()[0].click()

func get_choise(_Order_value,_Order_type):
	auction_bool = true
	After_Turn()

func auction_loop_Turn():
	Obj_Order["Numbers"].visible = true
	auction_var += 1
	auction_bool = false
# ------------- AUCTION ------------------

func After_Trick():
	var local_turn = Get_Turn(1,Turn)
	for x in GM.Discarded:
		if x.Data["Color"] == 2:
			auction[local_turn][0] += 1
		elif x.Data["Color"] == 1 and x.Data["Number"] == 12:
			auction[local_turn][0] += 13
		elif ch("M1") and x.Data["Color"] == 4 and x.Data["Number"] == 11:
			auction[local_turn][1] -= 10
	GM.Players[local_turn][0].set_label(false,str(auction[local_turn][0] + auction[local_turn][1]))

func After_loop():
	start_loop = true
	# Tu podliczyc punkty
	var score = []# ta tablica przechowuje punkty w kolejnosci graczy (0 player) - (1,2,3 host)
		
	for i in range(player_count):
		var calc
		calc = auction[i][0] + auction[i][1]
	
		calc += full_score[i][0]
		if not ch("M2") and calc<0: calc = 0
		score.append(calc)
		full_score[i][0] = calc
	
	GM.score_board.Data_update(score)
	
	for i in range(player_count):
		if full_score[i][0] >= Hearts_count["End var"]: End_Game()
	

func End_Game():
	for i in GM.Players.size():
		if not GM.ranking.has(GM.Players[i]):
			GM.ranking.append([GM.Players[i][0],full_score[i][0]])
	GM.ranking.sort_custom(func(a, b): return a[1] > b[1])
	SMen.change_scene("res://scens/Leader_Board.tscn")
