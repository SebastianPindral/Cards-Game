extends trick_taking
class_name Spades

# 4 lub 2 osob

func config_character(Data):
	player_count = Data["OCL_name_list"][0][1]
	Turn = player_count-1
	Atut = 1 # Pik

func After_Trick(_win):
	pass
	#tutaj przypisac punkty wygranemu i dac mu rozpoczac kolejna kolejke

func After_loop():
	pass
