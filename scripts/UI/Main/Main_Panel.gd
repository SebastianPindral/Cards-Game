extends Control
@onready var start: Button = $VBoxContainer/Start
@onready var exit: Button = $VBoxContainer/Exit
@onready var Choice_game: Control = $"../Choice_game"
@onready var config_game: Control = $"../Config_game"

func _ready() -> void:
	start.pressed.connect(_on_start_pressed)
	exit.pressed.connect(_on_exit_pressed)
	Choice_game.visible = false
	config_game.visible = false
	visible = true

func _on_start_pressed():
	visible = false
	Choice_game.visible = true

func _on_exit_pressed():
	get_tree().quit()
