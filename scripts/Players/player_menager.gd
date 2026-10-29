extends Node2D
const PLAYER = preload("res://Prefabs/player.tscn")
@onready var table: Node2D = $"../Table"

var Actors = []

func _ready() -> void:
	add_to_group("Player_menager")
	var x = PLAYER.instantiate()
	add_child(x)
	x.set_this("player")
	Actors.append(x)
	for i in (GMaster.Player_count() - 1):
		x = PLAYER.instantiate()
		add_child(x)
		x.set_this("host",i+1)
		Actors.append(x)

func deal_cards(pid,count):
	Actors[pid].take_cards(table.send(count))

func Actor_poz(index):
	return Actors[index-1].global_position

func Actor_play(index):
	Actors[index-1].play()
