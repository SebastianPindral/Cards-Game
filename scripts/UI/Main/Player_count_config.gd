extends VBoxContainer
@onready var config_game: Control = $"../../.."
@onready var label0: Label = $Label

@onready var minus: Button = $Player_count/minus
@onready var plus: Button = $Player_count/plus
@onready var label: Label = $Player_count/Label
var local_data
var max_value = 0
func _ready() -> void:
	minus.pressed.connect(minus_one)
	plus.pressed.connect(plus_one)
	label.text = str(0)

func get_value(index): return local_data[2][index]

func set_it(j):
	local_data = config_game.Data["OCL_name_list"][j]
	label0.text = local_data[0]
	max_value = local_data[2].size()-1
	label.text = str(get_value(local_data[1]))

func minus_one():
	if local_data[1] > 0:
		local_data[1] -= 1
		label.text = str(get_value(local_data[1]))

func plus_one():
	if local_data[1] < max_value:
		local_data[1] += 1
		label.text = str(get_value(local_data[1]))
