extends Node
class_name q_load
var icons = {}

func get_icons(i:String):
	if icons.get(i) != null:
		return icons[i]

func load_icons(sets):
	var path = "res://assets/Cards/"+sets+"/"
	
	icons["Back"] = load(path+"Back.png")
	icons["Front"] = load(path+"Front.png")
	
	var dir = DirAccess.open(path + "Colors/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".png"):
				var index = file_name.get_basename() 
				icons[index] = load(path + "Colors/" + file_name)
			file_name = dir.get_next()
	
	dir = DirAccess.open(path + "Numbers/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".png"):
				var index = file_name.get_basename() 
				icons[index] = load(path + "Numbers/" + file_name)
			file_name = dir.get_next()
