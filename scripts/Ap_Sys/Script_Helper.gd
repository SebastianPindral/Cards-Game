extends Node
class_name Script_Helper

func if_in_loop(conditions:Array) -> bool:
	for x in conditions:
		if not x.call():
			return false
	return true


# moze uryzje do polaczenia tekstu w grze z zmiana wartosci
#signal value_changed(new_value)
#var _my_value := 0

#var my_value:
#	get:
#		return _my_value
#	set(value):
#		_my_value = value
#		emit_signal("value_changed", value)

#func _ready():
#	$Label.value_changed.connect(_on_value_changed)

#func _on_value_changed(new_value):
#	$Label.text = str(new_value)
