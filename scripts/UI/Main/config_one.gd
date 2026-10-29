extends Control
@onready var config_game: Control = $"../../.."
@onready var button: Button = $Button
@onready var sprite_2d: Sprite2D = $Sprite2D

var Config_text = ""
var button_state = true
var shadow_size = Vector2(100,350)

func _ready() -> void:
	button.pressed.connect(click)
	button.mouse_entered.connect(enter)
	button.mouse_exited.connect(exiter)

func enter():
	pass

func exiter():
	pass

func create(text0,def_state):
	sprite_2d.texture = SMen.QL.get_icons("Back")
	SMen.Resize(sprite_2d,shadow_size)
	custom_minimum_size.x = shadow_size.y
	custom_minimum_size.y = shadow_size.x
	button.custom_minimum_size.x = shadow_size.y
	button.custom_minimum_size.y = shadow_size.x
	sprite_2d.position = size/2
	Config_text = text0
	button.text = text0
	if def_state:
		click()
		click()
	else:	click()

func click():
	button_state = not button_state
	config_game.Data[Config_text][1] = button_state
	match button_state:
		true:
			sprite_2d.texture = SMen.QL.get_icons("Clear_card")
			SMen.Resize(sprite_2d,shadow_size)
			button.text = Config_text
		false:
			sprite_2d.texture = SMen.QL.get_icons("Back")
			SMen.Resize(sprite_2d,shadow_size)
			button.text = ""
