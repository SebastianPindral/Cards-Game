extends BaseGame
class_name trick_taking # klasa rodzic dla gier z wykladaniem jednej karty przez wszystkich graczy na ture
var base_conditions = func() -> bool: return (Active_card.Data["Color"] == card.Data["Color"])

func _init() -> void:
	Order_choice_list = {
	"Tricks":[0,1,2,3,4,5,6,7,8,9,10,11,12,13]
	}
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

func config_character(Data):pass
func set_choise_obj(Order_obj,Order_type):pass
func get_choise(Order_value,Order_type):pass

func Check_Hand(When,numer,Hand):pass
func Who_Starts_game():pass
func Throw_card(c):pass
func end_check():pass
func End_Game():pass

func End_loop():#funkcja wywolywana kiedy wszyscy wylorza lewe
	
	#tutaj podliczenie punktow za lewe
	
	GM.Reset_Stack()
	if GM.Players[0][0].On_Hand.size()==0:
		
		# Tutaj zakonczenie pelnego rozdania rozdania/wylorzenie ostatniej karty z reki i podliczenie punktow
		
		The_Deal()

func After_Turn():
	Next_Turn()
	if GM.Discarded.size() >= player_count:#koniec petli
		await SMen.wait_with_pause(0.5)
		End_loop()
	else:#jeden ruch w petli
		pass

func Legality_Check(c)->bool:return true
