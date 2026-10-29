extends HBoxContainer
@onready var config_game: Control = $"../../.."
@onready var label: Label = $Label
@onready var off_on: Button = $OFF_ON

var button_state = true

func _ready() -> void:
	off_on.pressed.connect(click)

func create(text0,def_state):
	label.text = text0
	if def_state:
		click()
		click()
	else:	click()


func click():
	button_state = not button_state
	config_game.Data[label.text][1] = button_state
	match button_state:
		true:
			var style = StyleBoxFlat.new()
			style.bg_color = Color(0, 1, 0) 
			off_on.add_theme_stylebox_override("normal", style)
			off_on.text = "ON"
		false:
			var style = StyleBoxFlat.new()
			style.bg_color = Color(1, 0, 0) 
			off_on.add_theme_stylebox_override("normal", style)
			off_on.text = "OFF"
