extends Node

var QuickLoad = q_load.new()

func _ready() -> void:
	get_viewport().physics_object_picking_sort = true
	get_viewport().physics_object_picking_first_only = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func wait_with_pause(seconds: float) -> void:
	while get_tree().paused:
		await get_tree().process_frame
	await get_tree().create_timer(seconds).timeout


func reorder_Stack(tab):
	var parent = tab[0].get_parent()
	for i in range(tab.size()):
		parent.move_child(tab[i], i)

func Resize(sprite,target_size):
	var tex_size = sprite.texture.get_size()
	sprite.scale = target_size / tex_size

func Move_Anim(obj,final_poz,final_rad,speed):
	var tween = create_tween()
	tween.parallel().tween_property(obj, "position", final_poz, speed)
	tween.parallel().tween_property(obj, "rotation", final_rad, speed)
