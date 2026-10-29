extends Control
@onready var resume: Button = $VBoxContainer/Resume
@onready var settings: Button = $VBoxContainer/Settings
@onready var quit: Button = $VBoxContainer/Quit
@onready var ui: Control = $"../UI"

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	resume.pressed.connect(_on_play_pressed)
	settings.pressed.connect(_on_settings_pressed)
	quit.pressed.connect(_on_quit_pressed)
	set_v(false)

func set_v(boolean):
	visible = boolean
	ui.visible = not boolean

func _unhandled_input(event):
	if event.is_action_pressed("Esc_pause"):
		get_tree().paused = not get_tree().paused
		if visible == false:
			set_v(true)
		else:
			set_v(false)

func _on_play_pressed():
	get_tree().paused = false
	set_v(false)

func _on_settings_pressed():
	pass

func _on_quit_pressed():
	get_tree().quit()
