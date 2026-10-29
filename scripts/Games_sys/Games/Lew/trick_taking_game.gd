extends BaseGame
class_name trick_taking # klasa rodzic dla gier z wykladaniem jednej karty przez wszystkich graczy na ture
var base_conditions = func() -> bool: return ((card.Data["Color"] != Atut) or color_broken)
var alter_conditions = func() -> bool: return (card.Data["Color"] == Active_card.Data["Color"])
var all_can = func() -> bool: return (true)
var color_broken = false
var Atut

func _init() -> void:
	Order_choice_list = {"Tricks":[0,1,2,3,4,5,6,7,8,9,10,11,12,13]}
	GM.Deck_size["count_colors"] = 4
	GM.Deck_size["count_numer"] = 13
	GM.Deck_size["count_jockers"] = 0
	GM.game_rule["Start_Cards"] = 13
	GM.game_rule["Deal_Stack_Cards"] = 0
	Throw_conditions.append(base_conditions)
	Order["Tricks"] = 0

func set_game():
	Who_Starts_game()
	change_rotation_direct()
	The_Deal()
	Next_Turn()

func The_Deal():
	GM.shuffle()
	for i in range(0,4):
		GM.deal_cards(i,13)

func set_poz_on_discard(c,dis_poz):
	var Actor_poz = (GM.Actor_poz(Turn) - GM.table.dis_node.global_position).angle()  
	var distance = 100
	SMen.Move_Anim(c,Vector2(distance, 0).rotated(Actor_poz) + dis_poz,0, 0.2)
	c.where_is("Discard",c.global_position)

func config_character(_Data):pass
func get_choise(_Order_value,_Order_type):pass

func Check_Hand(When,_numer,Hand):
	if When == 0:
		if GM.Discarded.size() == 0:
			await GM.Game.sig_to_con
			Active_card = null
			Throw_conditions = [base_conditions]
		else:
			for c in Hand:
				if Active_card == null: return
				if c.Data["Color"] == Active_card.Data["Color"]:
					Throw_conditions = [alter_conditions]
					return
			Throw_conditions = [all_can]


func Who_Starts_game():pass

func Before_Throw(c):
	if GM.Discarded.size() == 0:
		Active_card = c

func Throw_card(c):
	if c.Data["Color"] == Atut:
		color_broken = true

func calc_tt_win():
	var lewa = GM.Discarded
	var max0 = [0,0]
	var t_atut = false
	var i = 0
	for c in lewa:
		if c.Data["Color"] == Atut:
			if not t_atut:
				max0 = [i,c.Data["Number"]]
				t_atut = true
			elif c.Data["Number"] > max0[1]:
				max0 = [i,c.Data["Number"]]
		elif c.Data["Number"] > max0[1] and c.Data["Color"] == Active_card.Data["Color"] and not t_atut:
			max0 = [i,c.Data["Number"]]
		i += 1
	return max0

func give_turn_winner(winner:int):
	Turn_move(winner,Rotation_direct)

func After_Trick(_win):pass
func After_loop():pass

func End_loop():#funkcja wywolywana kiedy wszyscy wylorza lewe
	var win = calc_tt_win()
	give_turn_winner(win[0])
	After_Trick(win)
	
	GM.Reset_Stack()
	sig_to_con.emit()
	if GM.Players[0][0].On_Hand.size()==0:
		# Tutaj zakonczenie pelnego rozdania/wylorzenie ostatniej karty z reki i podliczenie punktow
		color_broken = false
		After_loop()
		
		The_Deal()

func After_Turn():
	if GM.Discarded.size() >= player_count:#koniec lewy
		await SMen.wait_with_pause(0.5) 
		End_loop()
	else:#jeden ruch w petli
		pass
	Next_Turn()

func Legality_Check(c)->bool:
	card = c
	return SHelp.if_in_loop(Throw_conditions)

func end_check():pass
func End_Game():pass
