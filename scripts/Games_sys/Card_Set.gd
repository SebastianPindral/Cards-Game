extends Node2D
@onready var table: Node2D = $"../Table"

const ONE_CARD = preload("res://Prefabs/ONE_Card.tscn")
var Card_Style = "Default"

func _ready() -> void:
	QuickLoad.load_icons(Card_Style)
	for j in range(2,15):
		for i in range(1,5):
			var item = ONE_CARD.instantiate() 
			add_child(item)
			item.Start(j,i)
			item.position = Vector2(-500,-500)
			GM.Stack.append(item)
