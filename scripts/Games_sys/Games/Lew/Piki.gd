extends trick_taking
class_name Piki
# 4 lub 2 osob
func set_game():
	Who_Starts_game()
	change_rotation_direct()
	GM.shuffle()
	for i in range(0,4):
		GM.deal_cards(i,13)
	Next_Turn()

func config_character(Data):
	player_count = Data["OCL_name_list"][0][1]
