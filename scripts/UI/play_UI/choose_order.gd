extends Control
const ORDER_BUTTONS = preload("res://Prefabs/UI/order_buttons.tscn")
var Orders = []
var xx = ["Karo","Kier","Pik","Trefl","clear"]
var xx2 = ["5","6","7","8","9","10","Q","clear"]
var radius = 300

func _ready() -> void:
	if GM.Game is Makao:
		choose_color()
		#choose_numbers()

func choose_color():
	var choose_count = 5
	var a1 = Control.new()
	a1.name = "Colors"
	Orders.append(a1)
	add_child(a1)
	for x in choose_count:
		var obj = ORDER_BUTTONS.instantiate()
		obj.set_button(radius,choose_count,Color.WHITE,"Colors/",xx[x])
		a1.add_child(obj)
		split_it(obj,x,choose_count)

func choose_numbers():
	var choose_count = 8
	var a2 = Control.new()
	a2.name = "Numbers"
	Orders.append(a2)
	add_child(a2)
	for x in choose_count:
		var obj = ORDER_BUTTONS.instantiate()
		obj.set_button(radius,choose_count,Color.WHITE,"Numbers/",xx2[x])
		a2.add_child(obj)
		split_it(obj,x,choose_count)

func split_it(obj1,index,size0):
	obj1.rotation =  (TAU / size0) * index - PI/2
