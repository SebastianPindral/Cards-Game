extends Node

var Players = {"1": true,"2": true,"3": true,"4": true}

var Turn = 1 # false jesli gracz nie moze nic robic

func Player_count():
	return Players.size()

func Next_Turn():
	if Turn < Players:
		Turn += 1
	else: Turn = 1
	print(Turn)
