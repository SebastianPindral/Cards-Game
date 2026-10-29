extends Node


func _ready() -> void:
	get_viewport().physics_object_picking_sort = true
	get_viewport().physics_object_picking_first_only = true

func wait_with_pause(seconds: float) -> void:
	while get_tree().paused:
		await get_tree().process_frame
	await get_tree().create_timer(seconds).timeout

func Resize(sprite,target_size):
	var tex_size = sprite.texture.get_size()
	sprite.scale = target_size / tex_size

func Move_Anim(obj,final_poz,final_rad,speed):
	var tween = create_tween()
	tween.parallel().tween_property(obj, "position", final_poz, speed)
	tween.parallel().tween_property(obj, "rotation", final_rad, speed)
