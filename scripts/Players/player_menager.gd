extends Node2D
const PLAYER = preload("res://Prefabs/player.tscn")
@onready var table: Node2D = $"../Table"

func _ready() -> void:
	add_to_group("Player_menager")
	var x = PLAYER.instantiate()
	add_child(x)
	x.set_this("player")
	GM.Players.append(x)
	for i in (GM.Player_count() - 1):
		x = PLAYER.instantiate()
		add_child(x)
		x.set_this("host",i+1)
		GM.Players.append(x)
