extends Node2D
@onready var label: Label = $Label
@onready var label2: Label = $Label2

func _ready() -> void:
	label.position = Vector2(50,250)
	label2.position = Vector2(50,350)

func set_label(type,vari):
	if	vari == 0:label.text = ""
	elif type == "Colors":
		match vari:
			1: label.text = "Pik"
			2: label.text = "Kier"
			3: label.text = "Trefl"
			4: label.text = "Karo"
	else:	label.text = str(vari)

func set_label2(type,vari):
	if	vari == 0:label2.text = ""
	elif type == "Colors":
		match vari:
			1: label2.text = "Pik"
			2: label2.text = "Kier"
			3: label2.text = "Trefl"
			4: label2.text = "Karo"
	else:	label2.text = str(vari)
