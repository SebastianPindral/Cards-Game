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
			item.position = Vector2(100,130)
			Deck.append(item)
