extends BaseGame
class_name trick_taking # klasa rodzic dla gier z wykladaniem jednej karty przez wszystkich graczy na ture
var base_conditions = func() -> bool: return (color_broken or (card.Data["Color"] != color_blocked))#poczatek lewy
var alter_conditions = func() -> bool: return (card.Data["Color"] == Active_card.Data["Color"])#dokladanie do koloru
var all_can = func() -> bool: return (true)#dokladanie jak nie ma koloru
var color_broken = false
var color_blocked
var Atut

func _init() -> void:
	GM.Deck_size["count_colors"] = 4
	GM.Deck_size["count_numer"] = 13
	GM.Deck_size["count_jockers"] = 0
	GM.game_rule["Start_Cards"] = 13
	GM.game_rule["Deal_Stack_Cards"] = 0
	Throw_conditions.append(base_conditions)

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

func Check_have_color(Hand):
	for c in Hand:
		if c.Data["Color"] != color_blocked:
			return color_broken
	return true

func Start_Player_Turn(_numer,Hand):
	if auction_var < player_count:# tura licytacji kazdego gracza
		auction_loop_Turn()
	if GM.Discarded.size() == 0:# pierwsza karta z lewy
		await catch_signal()
		Active_card = null
		Throw_conditions = [base_conditions]
		color_broken = Check_have_color(Hand)
	else:# kolejne karty z lewy
		if Active_card == null: 
			Throw_conditions = [base_conditions]
			return
		for c in Hand:
			if c.Data["Color"] == Active_card.Data["Color"]:
				Throw_conditions = [alter_conditions]
				return
		Throw_conditions = [all_can]

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
	Turn_move(winner)

func After_Trick(_win):pass #po kazdej lewie
func After_loop():pass # po kazdej petli

#to ma adpowiadac za lizytacje, wymiany kart w kierkach itp
func auction_loop_Turn():pass

func End_loop():#funkcja wywolywana kiedy wszyscy wylorza lewe
	var win = calc_tt_win()
	give_turn_winner(win[0])
	After_Trick(win)#podliczanie punkow i inne operacje wlasne po kazdej lewie
	
	GM.Reset_Stack()
	throw_signal()
	was_emited = true
	if GM.Players[0][0].On_Hand.size()==0:
		# Tutaj zakonczenie pelnego rozdania/wylorzenie ostatniej karty z reki i podliczenie punktow
		color_broken = false
		
		The_Deal()
		
		After_loop()

func After_Turn():
	if GM.Discarded.size() >= player_count:#koniec lewy
		await SMen.wait_with_pause(0.5) 
		End_loop()
	else:#jeden ruch w petli
		pass
	if auction_var == player_count:
		auction_var += 1
		auction_bool = true
	Next_Turn()

func Legality_Check(c)->bool:
	card = c
	return SHelp.if_in_loop(Throw_conditions)

func end_check():pass
func End_Game():pass
