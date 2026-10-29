extends VBoxContainer
@onready var quit: Button = $"../Quit"

var i = 0
func _ready() -> void:
	quit.pressed.connect(_on_quit_pressed)
	for p in GM.ranking:
		i+=1
		var l = Label.new()
		l.text = str(i) +") "+ p[0].typ + str(p[0].numer) + " : " + str(p[1])
		add_child(l)

func _on_quit_pressed():
	get_tree().quit()
