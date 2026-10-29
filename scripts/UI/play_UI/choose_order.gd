extends Control
const ORDER_BUTTONS = preload("res://Prefabs/UI/order_buttons.tscn")
var Orders = []
var color_choise = ["Karo","Kier","Pik","Trefl","clear"]
var number_choise = ["5","6","7","8","9","10","Q","clear"]
var radius = 300

func _ready() -> void:
	if GM.Game is Makao:
		Choice_color()
		#Choice_numbers()

func Choice_color():
	var a1 = Control.new()
	a1.name = "Colors"
	Orders.append(a1)
	add_child(a1)
	for x in color_choise.size():
		var obj = ORDER_BUTTONS.instantiate()
		obj.set_button(radius,color_choise.size(),Color.WHITE,"Colors/",color_choise[x])
		a1.add_child(obj)
		split_it(obj,x,color_choise.size())

func Choice_numbers():
	var a2 = Control.new()
	a2.name = "Numbers"
	Orders.append(a2)
	add_child(a2)
	for x in number_choise.size():
		var obj = ORDER_BUTTONS.instantiate()
		obj.set_button(radius,number_choise.size(),Color.WHITE,"Numbers/",number_choise[x])
		a2.add_child(obj)
		split_it(obj,x,number_choise.size())

func split_it(obj1,index,size0):
	obj1.rotation =  (TAU / size0) * index - PI/2
