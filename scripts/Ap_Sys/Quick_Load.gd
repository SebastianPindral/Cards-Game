extends Node
class_name q_load
var icons = {}
var cursor = preload("res://assets/Other/Cursor/hover.png")

func set_cursor_icon(i:int = 0):
	match i:
		1:	Input.set_custom_mouse_cursor(cursor)
		_:	Input.set_custom_mouse_cursor(null)

func get_icons(i:String):
	if icons.get(i) != null:
		return icons[i]
	else: print("Load_error")

func load_icons(sets):
	var path = "res://assets/Cards/"+sets+"/"
	icons["Back"] = load(path+"Back.png")
	icons["Clear_card"] = load("res://assets/Cards/Clear_card.png")
	
	path = path + "Fronts/"
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".png"):
				var index = file_name.get_basename() 
				icons[index] = load(path + file_name)
			file_name = dir.get_next()
	
