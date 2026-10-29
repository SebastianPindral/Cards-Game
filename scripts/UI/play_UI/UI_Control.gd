extends Control
@onready var knock_button: Button = $knock_button
@onready var pass_button: Button = $Pass_button

func _ready() -> void:
	knock_button.pressed.connect(knock_b)
	pass_button.pressed.connect(pass_b)

func knock_b():
	pass


func pass_b():
	pass
