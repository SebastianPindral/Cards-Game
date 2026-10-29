extends VBoxContainer
@onready var config_game: Control = $"../../.."
@onready var label0: Label = $Label

@onready var minus: Button = $Player_count/minus
@onready var plus: Button = $Player_count/plus
@onready var label: Label = $Player_count/Label

var atrib = ""
func _ready() -> void:
	minus.pressed.connect(minus_one)
	plus.pressed.connect(plus_one)
	label.text = str(0)

func set_it(a,title):
	atrib = a
	label0.text = title
	label.text = str(config_game.Data[atrib][0])

func minus_one():
	if config_game.Data[atrib][0] > config_game.Data[atrib][1]:
		config_game.Data[atrib][0] -= 1
		label.text = str(config_game.Data[atrib][0])

func plus_one():
	if config_game.Data[atrib][0] < config_game.Data[atrib][2]:
		config_game.Data[atrib][0] += 1
		label.text = str(config_game.Data[atrib][0])
