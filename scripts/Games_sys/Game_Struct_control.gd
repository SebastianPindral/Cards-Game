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
	set_game()

func shuffle():
	Stack.shuffle()
	reorder_Stack(Stack)

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

func Card_is_Used(c):
	Discarded.append(c)
	reorder_Stack(Discarded)
	dis_node.Set_poz(c)
	#Tutaj operacje na rzuconej karcie
	#GMaster.Next_Turn()

func reorder_Stack(tab):
	var parent = tab[0].get_parent()
	for i in range(tab.size()):
		parent.move_child(tab[i], i)
