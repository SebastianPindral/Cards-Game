extends Node2D
const PLAYER = preload("res://Prefabs/player.tscn")
@onready var table: Node2D = $"../Table"

func _ready() -> void:
	add_to_group("Player_menager")
	var x = PLAYER.instantiate()
	add_child(x)
	x.set_this("player")
	set_player_poz(x,0)
	GM.Players.append(x)
	for i in (GM.Player_count() - 1):
		x = PLAYER.instantiate()
		add_child(x)
		x.set_this("host",i+1)
		set_player_poz(x,i+1)
		GM.Players.append(x)


func set_player_poz(pl,numer):
	match numer:
		0:	pl.global_position = Vector2(900,850)
		1:
			pl.global_position = Vector2(100,450)
			pl.rotation = PI/2
		2:	pl.global_position = Vector2(900,100)
		3:
			pl.global_position = Vector2(1800,450)
			pl.rotation = -PI/2
