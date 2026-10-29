extends trick_taking
class_name Spades

# 4 lub 2 osob

func config_character(Data):
	Order_choice_list = {"Numbers":["0","1","2","3","4","5","6","7","8","9","10","11","12","13"]}
	player_count = Data["OCL_name_list"][0][1]
	Turn = player_count-1
	Atut = 1 # Pik
	color_blocked = 1

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

func After_Trick(_win):
	var local_turn = Get_Turn(1)
	auction[local_turn][0] += 1
	GM.Players[local_turn][0].set_label(false,str(auction[local_turn][0])+"/"+str(auction[local_turn][1]))


func After_loop():
	# Tu podliczyc punkty
	var score = []# ta tablica przechowuje punkty w kolejnosci graczy (0 player) - (1,2,3 host)
	GM.score_board.Data_update(score)
	
	auction_var = 0
	auction.clear()
