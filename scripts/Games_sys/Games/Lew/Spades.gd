extends trick_taking
class_name Spades
var alter_conditions = func() -> bool: return (true) #zrobic aby mozna bylo rzucic innego koloru jak nie ma tego samego
var spades_broken = false
# 4 lub 2 osob


func config_character(Data):
	player_count = Data["OCL_name_list"][0][1]
	Turn = player_count-1

func Check_Hand(_When,_numer,_Hand):
	if GM.Discarded.size() >= player_count:
		await GM.Game.sig_to_con
	else:
		pass # TUTAJ! zrobic aby mozna bylo rzucic innego koloru jak nie ma tego samego

func Before_Throw(c):
	if GM.Discarded.size() == 0:
		Active_card = c
		#Throw_conditions.erase(base_conditions)
		#Throw_conditions.append(alter_conditions)

func Throw_card(c):
	pass


func After_Trick():
	pass
	#Throw_conditions.append(base_conditions)
	#Throw_conditions.erase(alter_conditions)

func After_loop():pass

func Legality_Check(c)->bool:
	card = c
	if Active_card == null: return true
	return SHelp.if_in_loop(Throw_conditions)
