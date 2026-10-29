extends BaseGame
class_name trick_taking # klasa rodzic dla gier z wykladaniem jednej karty przez wszystkich graczy na ture

func _init() -> void:pass
func config_character(Data):pass
func set_choise_obj(Order_obj,Order_type):pass
func get_choise(Order_value,Order_type):pass
func set_poz_on_discard(c,dis_poz):pass
func Check_Hand(When,numer,Hand):pass
func Who_Starts_game():pass
func set_game():pass
func Throw_card(c):pass

func After_Turn():
	Next_Turn()

func Legality_Check(c)->bool:return true
