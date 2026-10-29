extends Node2D
@onready var players: Node2D = $"../Players"
@onready var deck: Node2D = $"../Deck"
#----------------------------
@onready var stack_node: Node2D = $Stack
@onready var dis_node: Node2D = $Discarded

var Stack = []
var Discarded = [] # zuzyte karty

func _ready() -> void:
	add_to_group("Table")
	GMaster.Start_Game()

func shuffle():
	Stack.shuffle()
	reorder_Stack(Stack)

func set_game(players_count,card_count):
	shuffle()
	for i in range(0,players_count):
		players.deal_cards(i,card_count)
	stack_node.Set_Stack(Stack)

func send(i):
	var t = []
	for x in range(min(i, Stack.size()) - 1, -1, -1):
		t.append(Stack[x])
		Stack.remove_at(x)
	return t

func Card_is_Used(c):
	Discarded.append(c)
	reorder_Stack(Discarded)
	dis_node.Set_poz(c)
	GMaster.card_function(c)

func reorder_Stack(tab):
	var parent = tab[0].get_parent()
	for i in range(tab.size()):
		parent.move_child(tab[i], i)
