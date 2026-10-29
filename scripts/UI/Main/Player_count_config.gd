extends VBoxContainer
@onready var config_game: Control = $"../../.."

@onready var minus: Button = $Player_count/minus
@onready var plus: Button = $Player_count/plus

@onready var label: Label = $Player_count/Label
func _ready() -> void:
	minus.pressed.connect(minus_one)
	plus.pressed.connect(plus_one)
	label.text = str(0)

func set_it():
	label.text = str(config_game.Data["playercount"][0])

func minus_one():
	if config_game.Data["playercount"][0] > config_game.Data["playercount"][1]:
		config_game.Data["playercount"][0] -= 1
		label.text = str(config_game.Data["playercount"][0])

func plus_one():
	if config_game.Data["playercount"][0] < config_game.Data["playercount"][2]:
		config_game.Data["playercount"][0] += 1
		label.text = str(config_game.Data["playercount"][0])
