extends Node
class_name BaseGame
var characteristics = {}

# nieokreslona ilosc warunkow do spelnienia aby rzucic karta
var Throw_conditions = []
#rzadanie liczby lub coloru
var Order = 0

func characteristic(text,state):
	characteristics[text] = state

func Legality_Check(_card)->bool:return false
