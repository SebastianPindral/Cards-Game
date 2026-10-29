extends Node2D
@onready var table: Node2D = $"../Table"

const ONE_CARD = preload("res://Prefabs/ONE_Card.tscn")
var Card_Style = "Default"

func _ready() -> void:
	SMen.QL.load_icons(Card_Style)
	for x in GM.Deck_size["count_decks"]:#ile talii na stole
		for j in range(14 + GM.Deck_size["count_jockers"],14 - GM.Deck_size["count_numer"],-1):#jaki rozmiar + czy joker
			for i in range(1,GM.Deck_size["count_colors"] +1):#ile kolorow
				var item = ONE_CARD.instantiate() 
				add_child(item)
				item.Start(j,i)
				item.position = Vector2(-500,-500)
				GM.Stack.append(item)
				if j>14:break
