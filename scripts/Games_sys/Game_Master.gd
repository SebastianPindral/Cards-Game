extends Node

var Player_count = 4

var Turn = 1 # false jesli gracz nie moze nic robic

func Set_Players():
	return Player_count

func Next_Turn():
	if Turn < Player_count:
		Turn += 1
	else: Turn = 1
	print(Turn)
