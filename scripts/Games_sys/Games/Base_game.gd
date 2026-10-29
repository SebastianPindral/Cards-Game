extends Node
class_name BaseGame
signal sig_to_con()
#konfiguracja gry
var characteristics = {}

# nieokreslona ilosc warunkow do spelnienia aby rzucic karta
var Throw_conditions = []
#rzadanie liczby lub coloru
var Obj_Order = {}
var Order = {}

func characteristic(text,state):	characteristics[text] = state

func Legality_Check(_card)->bool:return false
func set_choise_obj(_Order_obj,_Order_type):pass
func get_choise(_Order_value,_Order_type):pass
func set_game(): pass
func Before_Throw(_c): pass
func Throw_card(_c): pass
func Get_from_Stack(_id):pass
func set_poz_on_discard(_c,_dis_poz):pass

func stop():	sig_to_con.emit()
