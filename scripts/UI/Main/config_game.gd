extends Control
@onready var choose_game: Control = $"../choose_game"
@onready var back: Button = $HBoxContainer/VBC0/Back
@onready var start: Button = $HBoxContainer/VBC0/Start

const CONFIG_ONE = preload("res://Prefabs/UI_and_Main/config_one.tscn")
var type
var i = 1
var config_list = []
var player_min_max = [0,0]
func _ready() -> void:
	back.pressed.connect(_on_back_pressed)
	start.pressed.connect(_on_start_pressed)


func set_config_options(t):
	type = t
	var file = FileAccess.open("res://Data/"+type+"List.txt", FileAccess.READ)
	if file:
		var min_max = file.get_line().split("\t")
		player_min_max[0] = int(min_max[0])
		player_min_max[1] = int(min_max[1])
		while not file.eof_reached():
			var line = file.get_line()
			var parts = line.split("\t")
			if parts.size() <= 1: continue
			var state = parts[1].to_lower() == "true"
			var description = parts[2]                    #Zrobic!!!!!!!!!!!!!!!!!
			var bu = CONFIG_ONE.instantiate()
			var btn = get_node("HBoxContainer/VBC" + str(i))
			btn.add_child(bu)
			if btn.get_child_count()>9:	i+=1
			bu.create(parts[0],state)
			config_list.append(bu)

func _on_start_pressed():
	GM.new_game(type)
	GM.player_count = int($HBoxContainer/VBC0/VBoxContainer/Player_count/Label.text)
	for bu in config_list:
		GM.Game.characteristic(bu.label.text,bu.button_state)
	SMen.change_scene("res://scens/Cards_Games.tscn")

func _on_back_pressed():
	config_list.clear()
	visible = false
	choose_game.visible = true
