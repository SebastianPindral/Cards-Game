extends Control
@onready var start: Button = $VBoxContainer/Start
@onready var exit: Button = $VBoxContainer/Exit
@onready var choose_game: Control = $"../choose_game"
@onready var config_game: Control = $"../Config_game"

func _ready() -> void:
	start.pressed.connect(_on_start_pressed)
	exit.pressed.connect(_on_exit_pressed)
	choose_game.visible = false
	config_game.visible = false
	visible = true

func _on_start_pressed():
	visible = false
	choose_game.visible = true

func _on_exit_pressed():
	get_tree().quit()
