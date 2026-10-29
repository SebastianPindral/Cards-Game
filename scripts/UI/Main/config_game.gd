extends Control
@onready var Choice_game: Control = $"../Choice_game"
@onready var vbc_0: VBoxContainer = $HBoxContainer/VBC0

@onready var back: Button = $HBoxContainer/VBC0/Back
@onready var start: Button = $HBoxContainer/VBC0/Start
var Set_value = []
const SET_SOME_COUNT = preload("res://Prefabs/Main/set_some_count.tscn")

const CONFIG_ONE = preload("res://Prefabs/Main/config_one.tscn")
var type
var i = 1
var config_list = []
var Data
func _ready() -> void:
	back.pressed.connect(_on_back_pressed)
	start.pressed.connect(_on_start_pressed)

func set_config_options(t):
	type = t
	Data = SMen.SJ.load_json(type)
	
	for j in range(0,Data["OCL_name_list"].size()):
		var x = SET_SOME_COUNT.instantiate()
		Set_value.append(x)
		vbc_0.add_child(x)
		vbc_0.move_child(x,j+1)
		x.set_it(j,Data["OCL_name_list"][j][0])
	
	var sorted_keys = Data.keys()
	sorted_keys.erase("OCL_name_list")
	sorted_keys.sort_custom(func(a, b):return Data[a][0] < Data[b][0])
	
	for x in sorted_keys:
		#var description = Data[x][2] #Zrobic!!!!!!!!!!!!!!!!!
		var bu = CONFIG_ONE.instantiate()
		var btn = get_node("HBoxContainer/VBC" + str(i))
		btn.add_child(bu)
		if btn.get_child_count()>=7:	i+=1
		bu.call_deferred("create",x,Data[x][1])
		config_list.append(bu)

func _on_start_pressed():
	GM.new_game(type)
	GM.Game.config_character(Data)
	SMen.SJ.save_json(type,Data)
	SMen.change_scene("res://scens/Cards_Games.tscn")

func _on_back_pressed():
	var nodee = get_node("HBoxContainer/VBC0")
	var count = nodee.get_child_count()
	if count <= 2:return 
	for i in range(count - 2, 0, -1):
		var child = nodee.get_child(i)
		nodee.remove_child(child)
		child.queue_free()
		
	for j in range(1,5):
		var nodi = get_node("HBoxContainer/VBC" + str(j))
		for ch in nodi.get_children():
			nodi.remove_child(ch)
			ch.queue_free()
		get_node("HBoxContainer/VBC" + str(i))
	config_list.clear()
	visible = false
	Choice_game.visible = true
