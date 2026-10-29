extends Control
@onready var knock_button: Button = $knock_button
@onready var pass_button: Button = $Pass_button
@onready var score_board: VBoxContainer = $Score_board

func _ready() -> void:
	knock_button.pressed.connect(knock_b)
	pass_button.pressed.connect(pass_b)
	GM.score_board = score_board

func knock_b():
	GM.Game.Knock_Knock()

func pass_b():
	pass
