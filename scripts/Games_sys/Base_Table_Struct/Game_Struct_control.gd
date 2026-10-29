extends Node2D
@onready var players: Node2D = $"../Players"
@onready var deck: Node2D = $"../Deck"
#----------------------------
@onready var stack: Node2D = $Stack
@onready var dis_node: Node2D = $Discarded
@onready var spin: Sprite2D = $Discarded/Spin
@onready var cursor: Sprite2D = $Discarded/Cursor

func _ready() -> void:
	add_to_group("Table")
	GM.Start_Game(self)

func Cards_is_Used(x:Array):
	for one in x:
		GM.Discarded.append(one)
		dis_node.Set_poz(one)
		GM.card_function(one)
