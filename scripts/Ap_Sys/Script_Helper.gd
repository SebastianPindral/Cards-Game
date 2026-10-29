extends Node
class_name Script_Helper

func if_in_loop(conditions:Array) -> bool:
	for x in conditions:
		if not x.call():
			return false
	return true
