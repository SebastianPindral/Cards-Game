extends Control
@onready var config_game: Control = $"../../.."
@onready var button: Button = $Button
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var texture_button: TextureButton = $TextureButton
var posible_state = {true:true,false:false}
var Config_text = ""
var button_state = true
var shadow_size = Vector2(130,300)

func _ready() -> void:
	texture_button.pressed.connect(click.bind(true))
	button.pressed.connect(click)
	button.mouse_entered.connect(enter)
	button.mouse_exited.connect(exiter)
	texture_button.modulate = Color(0,1,0)
	texture_button.visible = false

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
	if def_state is not bool:
		posible_state[true] = int(def_state) if def_state > 0.0 else 1
		posible_state[false] = 0
		if def_state == 2:
			texture_button.button_pressed = true
	
	if def_state in [true,1.0,2.0]:
		click()
		click()
	elif def_state in [false,0.0]:
		click()

func click(tex=false):
	if tex:
		match texture_button.button_pressed:
			true:	posible_state[true] = 2
			false:	posible_state[true] = 1
	else:
		button_state = not button_state
	config_game.Data[Config_text][1] = posible_state[button_state]
	match button_state:
		true:
			sprite_2d.texture = SMen.QL.get_icons("Clear_card")
			SMen.Resize(sprite_2d,shadow_size)
			button.text = Config_text
			if posible_state[true] in [1,2]:
				texture_button.visible = true
		false:
			sprite_2d.texture = SMen.QL.get_icons("Back")
			SMen.Resize(sprite_2d,shadow_size)
			button.text = ""
			texture_button.visible = false
