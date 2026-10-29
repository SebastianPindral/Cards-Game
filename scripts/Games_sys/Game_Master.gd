extends Node

var Players = {"1": true,"2": true,"3": true,"4": true}

var Turn = 0 # false jesli gracz nie moze nic robic
var Rotation_direct = true
var game_rule = {"Start_Cards":5,"Deal_Stack_Cards":1}

func Player_count():
	return Players.size()

func Start_Game():
	change_rotation_direct()
	Next_Turn()
	get_tree().call_group("Table", "set_game",Players.size(),game_rule["Start_Cards"])

func change_rotation_direct():
	Rotation_direct = not Rotation_direct
	get_tree().call_group("spin", "Re_Direct")

func Deal_Stack_Cards(id):
	get_tree().call_group("Player_menager", "deal_cards",id,game_rule["Deal_Stack_Cards"])
	Next_Turn()

func card_function(card):
	Next_Turn()

func Next_Turn():
	if not Rotation_direct:
		if Turn < Players.size():
			Turn += 1
		else: Turn = 1
		get_tree().call_group("Cursor_target", "set_cursor_target",Turn)
	else:
		if Turn > 1:
			Turn -= 1
		else: Turn = Players.size()
		get_tree().call_group("Cursor_target", "set_cursor_target",Turn)
