extends Node2D
const ONE_CARD = preload("res://Prefabs/ONE_Card.tscn")
var Card_Style = "Default"
var Deck = []

func _ready() -> void:
	QuickLoad.load_icons(Card_Style)
	var N
	var C
	for i in range(1,5):
		for j in range(1,14):
			var item = ONE_CARD.instantiate() 
			match i:
				1: C = "Pik"
				2: C = "Trefl"
				3: C = "Kier"
				4: C = "Karo"
			match j:
				1:  N = "A"
				11: N = "J"
				12: N = "Q"
				13: N = "K"
				14: N = "Joker"# na razie pomijany
				_:
					N = str(j)
			add_child(item)
			item.Start(N,C)
			item.position = Vector2(900,400)
			Deck.append(item)

func send(i):
	var t = []
	for x in range(0,i):
		t.append(Deck[x])
		Deck.remove_at(x)
	return t
