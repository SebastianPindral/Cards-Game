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

func default_load(path):
	var dir = "res://Default_Data/"+path+"Data.json"

	var file = FileAccess.open(dir, FileAccess.READ)
	var content = file.get_as_text()
	file.close()

	var json = JSON.new()
	var err = json.parse(content)
	if err != OK:
		push_error("Błąd parsowania JSON: %s" % err)
		return null

	var data = json.get_data()
	return data

func load_json(path):
	var dir = OS.get_executable_path().get_base_dir()+"/Cards_games_Data/"
	if not DirAccess.dir_exists_absolute(dir):
		DirAccess.make_dir_recursive_absolute(dir)
	dir = dir+path+"Data.json"
	if not FileAccess.file_exists(dir):
		save_json(path,default_load(path))
	
	var file = FileAccess.open(dir, FileAccess.READ)
	var content = file.get_as_text()
	file.close()

	var json = JSON.new()
	var err = json.parse(content)
	if err != OK:
		push_error("Błąd parsowania JSON: %s" % err)
		return null

	var data = json.get_data()
	return data

func save_json(path,data):
	var dir = OS.get_executable_path().get_base_dir()+"/Cards_games_Data/"
	if not DirAccess.dir_exists_absolute(dir):
		DirAccess.make_dir_recursive_absolute(dir)
	dir = dir+path+"Data.json"
	var file = FileAccess.open(dir, FileAccess.WRITE)
	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()

func load_icons(sets):
	var path = "res://assets/Cards/"+sets+"/"
	icons["Back"] = load(path+"Back.png")
	
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
	
