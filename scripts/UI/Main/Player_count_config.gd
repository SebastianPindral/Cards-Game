extends VBoxContainer
@onready var config_game: Control = $"../../.."
@onready var label0: Label = $Label

@onready var minus: Button = $Player_count/minus
@onready var plus: Button = $Player_count/plus
@onready var label: Label = $Player_count/Label
var local_data
func _ready() -> void:
	minus.pressed.connect(minus_one)
	plus.pressed.connect(plus_one)
	label.text = str(0)

func set_it(j,title):
	label0.text = title
	local_data = config_game.Data["OCL_name_list"][j]
	label.text = str(local_data[1])

func minus_one():
	if local_data[1] > local_data[2]:
		local_data[1] -= 1
		label.text = str(local_data[1])

func plus_one():
	if local_data[1] < local_data[3]:
		local_data[1] += 1
		label.text = str(local_data[1])
