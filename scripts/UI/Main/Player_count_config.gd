extends VBoxContainer
@onready var config_game: Control = $"../../.."

@onready var minus: Button = $Player_count/minus
@onready var plus: Button = $Player_count/plus

@onready var label: Label = $Player_count/Label
var count = 2
func _ready() -> void:
	minus.pressed.connect(minus_one)
	plus.pressed.connect(plus_one)
	label.text = str(count)

func minus_one():
	if count > config_game.player_min_max[0]:
		count -= 1
		label.text = str(count)

func plus_one():
	if count < config_game.player_min_max[1]:
		count += 1
		label.text = str(count)
