extends Node2D
const PLAYER = preload("res://Prefabs/player.tscn")
@onready var deck: Node2D = $"../Deck"

var Actors = []

func _ready() -> void:
	var x = PLAYER.instantiate()
	add_child(x)
	x.set_this("player")
	Actors.append(x)
	for i in (GMen.Set_Players() - 1):
		x = PLAYER.instantiate()
		add_child(x)
		x.set_this("host",i+1)
		Actors.append(x)
	deal_cards()

func deal_cards():
	for i in Actors:
		i.take_cards(deck.send(5))
