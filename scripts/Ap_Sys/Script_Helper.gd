extends Node
class_name Script_Helper

func if_in_loop(conditions) -> bool:
	for x in conditions:	if x:	return true
	return false
