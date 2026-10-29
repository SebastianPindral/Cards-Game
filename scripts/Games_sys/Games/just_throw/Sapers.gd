extends just_throw
class_name Sapers #ekspolodujace kotki

func _init() -> void:
	GM.Deck_size["count_colors"] = 4
	GM.Deck_size["count_numer"] = 13
	GM.Deck_size["count_jockers"] = 1
	GM.game_rule["Deal_Stack_Cards"] = 1
	GM.game_rule["Start_Cards"] = 4

func config_character2(Data):
	player_count = get_value(0,Data)

func set_game():
	Who_Starts_game()
	change_rotation_direct()
	The_Deal()
	Next_Turn()

func The_Deal():
	GM.shuffle()
	for i in range(0,player_count):
		GM.deal_cards(i,GM.game_rule["Start_Cards"])

func Throw_card(c):
	pass
