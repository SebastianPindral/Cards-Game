extends Node2D
@onready var players: Node2D = $"../Players"
@onready var deck: Node2D = $"../Deck"
#----------------------------
@onready var stack_node: Node2D = $Stack

var Stack = []
var Discarded = [] # zuzyte karty

func _ready() -> void:
	set_game()

func shuffle():
	Stack.shuffle()
	reorder_children()

func set_game():
	shuffle()
	for i in range(0,4):
		players.deal_cards(i,5)
	stack_node.Set_Stack(Stack)

func send(i):
	var t = []
	for x in range(0,i):
		t.append(Stack[x])
		Stack.remove_at(x)
	return t

func reorder_children():
	var parent = Stack[0].get_parent()
	for i in range(Stack.size()):
		parent.move_child(Stack[i], i)
