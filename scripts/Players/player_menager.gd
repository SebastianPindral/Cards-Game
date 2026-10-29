extends Node2D
const PLAYER = preload("res://Prefabs/player.tscn")
@onready var deck: Node2D = $"../Deck"

var Actors = []

func _ready() -> void:
	var x = PLAYER.instantiate()
	add_child(x)
	x.get_child(0).set_this("player")
	Actors.append(x)
	for i in (GMen.Set_Players() - 1):
		x = PLAYER.instantiate()
		add_child(x)
		x.get_child(0).set_this("host",i+1)
		Actors.append(x)
	deal_cards()


func deal_cards():
	for i in Actors:
		i.get_child(0).take_cards(deck.send(5))
