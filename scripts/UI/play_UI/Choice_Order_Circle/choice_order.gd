extends Control
const ORDER_BUTTONS = preload("res://Prefabs/UI/order_buttons.tscn")
var Orders = {}# {"Colors":null,"Numbers":null}
var Choise
var radius = 300

func _ready() -> void:
	Choise = GM.Game.Order_choice_list
	if GM.Game is Makao:
		Choice_Circle("Colors")
		Choice_Circle("Numbers")
	elif GM.Game is Spades:
		Choice_Circle("Numbers")

func Choice_Circle(type):
	var a1 = Control.new()
	a1.name = type
	Orders[type] = a1
	GM.Game.set_choise_obj(a1,type)
	add_child(a1)
	for x in Choise[type].size():
		var obj = ORDER_BUTTONS.instantiate()
		obj.name = str(Choise[type][x])
		obj.set_button(radius,Choise[type].size(),Color.WHITE,type+"/",obj.name)
		a1.add_child(obj)
		split_it(obj,x,Choise[type].size())
		obj.CH.connect(Choise_emit.bind(type),CONNECT_DEFERRED)
	a1.visible = false

func Choise_emit(value,type):
	Orders[type].visible = false
	if value == "Q": value = 12
	elif value == "clear": value = 0
	elif type =="Colors": value = Choise[type].find(value)
	GM.Game.get_choise(int(value),type)

func split_it(obj1,index,size0):
	obj1.rotation =  (TAU / size0) * index - PI/2
