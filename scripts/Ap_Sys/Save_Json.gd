extends Node
class_name Save_Json

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
