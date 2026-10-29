extends Control
@onready var Choice_game: Control = $"../Choice_game"
@onready var vbc_0: VBoxContainer = $HBoxContainer/VBC0

@onready var back: Button = $HBoxContainer/VBC0/Back
@onready var start: Button = $HBoxContainer/VBC0/Start
@onready var playerc
@onready var Deckc
@onready var handc
const SET_SOME_COUNT = preload("res://Prefabs/Main/set_some_count.tscn")

const CONFIG_ONE = preload("res://Prefabs/Main/config_one.tscn")
var type
var i = 1
var config_list = []
var Data
func _ready() -> void:
	back.pressed.connect(_on_back_pressed)
	start.pressed.connect(_on_start_pressed)
	playerc = SET_SOME_COUNT.instantiate()
	Deckc = SET_SOME_COUNT.instantiate()
	handc = SET_SOME_COUNT.instantiate()
	vbc_0.add_child(playerc)
	vbc_0.add_child(Deckc)
	vbc_0.add_child(handc)
	vbc_0.move_child(playerc,1)
	vbc_0.move_child(Deckc,2)
	vbc_0.move_child(handc,3)
	
func set_config_options(t):
	type = t
	Data = SMen.SJ.load_json(type)
	playerc.set_it("playercount","Player Count:")
	Deckc.set_it("decksize","Deck Size:")
	handc.set_it("starthand","Start Hand Size:")
	
	var sorted_keys = Data.keys()
	sorted_keys.erase("playercount")
	sorted_keys.erase("decksize")
	sorted_keys.erase("starthand")
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
	GM.player_count = Data["playercount"][0]
	GM.Deck_size["count_decks"] = Data["decksize"][0]
	GM.game_rule["Start_Cards"] = Data["starthand"][0]
	var value
	for x in Data:
		if x == "playercount" or x == "decksize":continue
		if Data[x][1] is not bool:
			if Data[x][1] == 1:	value = [true,false]
			elif Data[x][1] == 0:	value = [false,false]
			elif Data[x][1] == 2:	value = [false,true]
		else:
			value = Data[x][1]
		GM.Game.characteristic(Data[x][0],value)
	SMen.SJ.save_json(type,Data)
	SMen.change_scene("res://scens/Cards_Games.tscn")

func _on_back_pressed():
	for j in range(1,5):
		var nodi = get_node("HBoxContainer/VBC" + str(j))
		for ch in nodi.get_children():
			nodi.remove_child(ch)
		get_node("HBoxContainer/VBC" + str(i))
	config_list.clear()
	visible = false
	Choice_game.visible = true
