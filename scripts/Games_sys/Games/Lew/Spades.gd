extends trick_taking
class_name Spades

# 4 lub 2 osob

func config_character(Data):
	player_count = Data["OCL_name_list"][0][1]
	Turn = player_count-1
	Atut = 1 # Pik

func Before_Throw(c):
	if GM.Discarded.size() == 0:
		Active_card = c

func Throw_card(c):
	if c.Data["Color"] == Atut:
		color_broken = true


func After_Trick():
	var lewa = GM.Discarded
	var max0 = [0,0]
	var i = 0
	for c in lewa:
		if c.Data["Number"] > max0[1]:#dodac uwzglednienie atutu
			max0 = [i,c.Data["Number"]]
		i += 1
	#tutaj przypisac punkty wygranemu i dac mu rozpoczac kolejna kolejke

func After_loop():
	color_broken = false
