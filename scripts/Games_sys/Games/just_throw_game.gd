extends BaseGame
class_name just_throw #klasa rodzic dla gier z rzucaniem kart na jeden stos i pobieraniem z drugiego

func set_poz_on_discard(c,dis_poz):
	SMen.Move_Anim(c,dis_poz,randf_range(-PI, PI),.2)
	c.where_is("Discard",dis_poz)

func Enemy_SI(_xx):pass
func set_game():pass
func The_Deal():pass
func config_character2(_Data):pass

func Before_Throw(_c):pass
func Throw_card(_c):pass
func After_Turn():pass

func Get_from_Stack(id):
	GM.deal_cards(id,1)


func Legality_Check(_card)->bool:return false

func end_check():pass #ktos zakonczyl gry
func End_Game():pass #koniec gry
