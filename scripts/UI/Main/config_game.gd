extends Control
@onready var choose_game: Control = $"../choose_game"
@onready var back: Button = $HBoxContainer/VBC0/Back
@onready var start: Button = $HBoxContainer/VBC0/Start
@onready var playerc: VBoxContainer = $HBoxContainer/VBC0/VBoxContainer

const CONFIG_ONE = preload("res://Prefabs/UI_and_Main/config_one.tscn")
var type
var i = 1
var config_list = []
var Data
func _ready() -> void:
	back.pressed.connect(_on_back_pressed)
	start.pressed.connect(_on_start_pressed)

func set_config_options(t):
	type = t
	Data = SMen.QL.load_json(type)
	playerc.set_it()
	
	var sorted_keys = Data.keys()
	sorted_keys.erase("playercount")
	sorted_keys.sort_custom(func(a, b):return Data[a][0] < Data[b][0])
	
	for x in sorted_keys:
		#var description = Data[x][2] #Zrobic!!!!!!!!!!!!!!!!!
		var bu = CONFIG_ONE.instantiate()
		var btn = get_node("HBoxContainer/VBC" + str(i))
		btn.add_child(bu)
		if btn.get_child_count()>=8:	i+=1
		bu.call_deferred("create",x,Data[x][1])
		config_list.append(bu)

func _on_start_pressed():
	GM.new_game(type)
	GM.player_count = int($HBoxContainer/VBC0/VBoxContainer/Player_count/Label.text)
	for x in Data:
		if x == "playercount":continue
		GM.Game.characteristic(Data[x][0],Data[x][1])
	SMen.QL.save_json(type,Data)
	SMen.change_scene("res://scens/Cards_Games.tscn")

func _on_back_pressed():
	for j in range(1,5):
		var nodi = get_node("HBoxContainer/VBC" + str(j))
		for ch in nodi.get_children():
			nodi.remove_child(ch)
		get_node("HBoxContainer/VBC" + str(i))
	config_list.clear()
	visible = false
	choose_game.visible = true
