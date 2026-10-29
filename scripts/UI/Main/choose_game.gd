extends Control
@onready var config_game: Control = $"../Config_game"
@onready var back: Button = $HBoxContainer/VBC1/Back
@onready var start_panel: Control = $"../Start_Panel"

const BASE_BUTTON = preload("res://Prefabs/Main/Base_button.tscn")

var games_list = ["Makao","Pan","Spades"]#,"Hearts","Plans","Bridge","Sapers"]
var i = 2
func _ready() -> void:
	back.pressed.connect(_on_back_pressed)
	for b in games_list:
		var bu = BASE_BUTTON.instantiate()
		bu.pressed.connect(_on_start_pressed.bind(b))
		bu.text = b
		var btn = get_node("HBoxContainer/VBC" + str(i))
		btn.add_child(bu)
		if btn.get_child_count()>9:	i+=1

func _on_back_pressed():
	visible = false
	start_panel.visible = true


func _on_start_pressed(type):
	config_game.set_config_options(type)
	visible = false
	config_game.visible = true
