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
	Data = SMen.QL.load_json("res://Data/"+type+"Data.json")
	playerc.set_it()
	for x in Data:
		if x == "playercount":	continue
		
		var description = Data[x][2] #Zrobic!!!!!!!!!!!!!!!!!
		var bu = CONFIG_ONE.instantiate()
		var btn = get_node("HBoxContainer/VBC" + str(i))
		btn.add_child(bu)
		if btn.get_child_count()>9:	i+=1
		bu.create(x,Data[x][1])
		config_list.append(bu)

func _on_start_pressed():
	GM.new_game(type)
	GM.player_count = int($HBoxContainer/VBC0/VBoxContainer/Player_count/Label.text)
	for x in Data:
		if x == "playercount":continue
		GM.Game.characteristic(Data[x][0],Data[x][1])
	SMen.QL.save_json("res://Data/"+type+"Data.json",Data)
	SMen.change_scene("res://scens/Cards_Games.tscn")

func _on_back_pressed():
	config_list.clear()
	visible = false
	choose_game.visible = true
