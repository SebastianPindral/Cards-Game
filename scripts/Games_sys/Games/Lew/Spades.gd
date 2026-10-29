extends trick_taking
class_name Spades

var spades_count = {"of penalty":0,"of count":0,"End var":0,"blind bid":0,"0 bid":0}

func get_value(index,Data): return Data["OCL_name_list"][index][2][Data["OCL_name_list"][index][1]]

func config_character2(Data):
	Order_choice_list = {"Numbers":["0","1","2","3","4","5","6","7","8","9","10","11","12","13"]}
	player_count = get_value(0,Data)
	spades_count["blind bid"] = get_value(1,Data)
	spades_count["0 bid"] = get_value(2,Data)
	spades_count["of penalty"] = get_value(3,Data)
	spades_count["of count"] = get_value(4,Data)
	spades_count["End var"] = get_value(5,Data) # do ilu sie gra
	Turn = player_count-1
	Atut = 1 # Pik
	color_blocked = 1
	for i in range(player_count):
		full_score[i] = [0,0] # 0-wynik , 1- overflow

func Enemy_SI(xx):
	if typeof(xx) is int:
		GM.Game.Obj_Order["Numbers"].get_children()[Turn].click()

# ------------- AUCTION --------------------
func get_choise(Order_value,_Order_type):
	auction[Turn] = [0,Order_value]
	GM.Players[Turn][0].set_label(false,"0/"+str(Order_value))
	auction_bool = true
	After_Turn()

func auction_loop_Turn():
	Obj_Order["Numbers"].visible = true
	auction_var += 1
	auction_bool = false
# ------------- AUCTION ------------------

func After_Trick():
	var local_turn = Get_Turn(1,Turn)
	auction[local_turn][0] += 1
	GM.Players[local_turn][0].set_label(false,str(auction[local_turn][0])+"/"+str(auction[local_turn][1]))

func After_loop():
	# Tu podliczyc punkty
	var score = []# ta tablica przechowuje punkty w kolejnosci graczy (0 player) - (1,2,3 host)
	if ch("MT") and player_count == 4:
		if auction[1][1] != 0 and auction[3][1] != 0:
			auction[1][1] += auction[3][1]
			auction[1][0] += auction[3][0]
		if auction[0][1] != 0 and auction[2][1] != 0:
			auction[0][1] += auction[2][1]
			auction[0][0] += auction[2][0]
		
	for i in range(player_count):
		var calc
		if auction[i][1] != 0:
			if ch("MT") and player_count == 4:
				if (i >= 2 and auction[i - 2][1] == 0) or (i<2 and auction[i + 2][1] == 0):pass
				elif i >= 2:
					score.append(full_score[i-2][0])
					continue
			calc = normal_card_collect(i)
		else:
			calc = zero_card_collect(i)
		
		if i >= 2:	i -= 2
	
		calc += full_score[i][0]
		if not ch("M2") and calc<0: calc = 0
		score.append(calc)
		full_score[i][0] = calc
		
	if ch("MT"):
		score.remove_at(1)
		score.remove_at(0)
	
	GM.score_board.Data_update(score)
	
	var score_d = full_score.duplicate()
	score_d.sort_custom(func(a, b): return a[0] < b[0])
	if (score_d[0] - score_d[1]) > spades_count["End var"]: End_Game()
	for i in range(player_count):
		if full_score[i][0] >= spades_count["End var"]: End_Game()

func normal_card_collect(player_index):
	var calc = auction[player_index][0] - auction[player_index][1]
	if calc < 0:
		if not ch("M1"): calc = -auction[player_index][1] * 10 # Part contract
		else: calc *= 10
	if calc >= 0: 
		full_score[player_index][1] += calc
		if full_score[player_index][1] >= spades_count["of count"]:
			full_score[player_index][0] -= spades_count["of penalty"]
			full_score[player_index][1] -= spades_count["of count"]
		calc = (auction[player_index][1] * 10) + calc
	return calc

func zero_card_collect(player_index):
	var calc = auction[player_index][0]
	if not ch("M3"):
		if calc == 0:
			calc = spades_count["0 bid"]
		else:
			calc = - spades_count["0 bid"]
	else:
		if calc == 0:
			calc = spades_count["0 bid"]
		else:
			calc = - spades_count["0 bid"] * calc
	return calc

func End_Game():
	for i in GM.Players.size():
		if not GM.ranking.has(GM.Players[i]):
			GM.ranking.append([GM.Players[i][0],full_score[i][0]])
	GM.ranking.sort_custom(func(a, b): return a[1] < b[1])
	SMen.change_scene("res://scens/Leader_Board.tscn")
