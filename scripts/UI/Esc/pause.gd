extends Control
@onready var resume: Button = $VBoxContainer/Resume
@onready var settings: Button = $VBoxContainer/Settings
@onready var quit: Button = $VBoxContainer/Quit

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	resume.pressed.connect(_on_play_pressed)
	settings.pressed.connect(_on_settings_pressed)
	quit.pressed.connect(_on_quit_pressed)
	visible = false

func _unhandled_input(event):
	if event.is_action_pressed("Esc_pause"):
		get_tree().paused = not get_tree().paused
		if visible == false:
			visible = true
		else:
			visible = false

func _on_play_pressed():
	get_tree().paused = false
	visible = false

func _on_settings_pressed():
	pass

func _on_quit_pressed():
	get_tree().quit()
