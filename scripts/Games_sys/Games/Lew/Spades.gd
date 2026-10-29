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

func get_choise(Order_value,_Order_type):
	auction.append([0,Order_value])
	GM.Players[Turn][0].set_label(false,Order_value)
	After_Turn()

func auction_loop_Turn():
	Obj_Order["Numbers"].visible = true
	auction_var += 1
	auction_bool = false

func After_Trick(_win):
	pass
	#tutaj przypisac punkty wygranemu i dac mu rozpoczac kolejna kolejke

func After_loop():
	auction_var = 0
	auction.clear()
