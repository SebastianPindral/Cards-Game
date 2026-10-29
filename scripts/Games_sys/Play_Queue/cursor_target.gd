extends Sprite2D
@onready var spin: Sprite2D = $"../Spin"
var self_size = Vector2(50,50)

var direct = 1
func _ready():
	add_to_group("Cursor_target")
	SMen.Resize(self,self_size)

func set_cursor_target(target):
	var Actor_poz = GM.Actor_poz(target) - get_parent().global_position
	var distance = spin.self_size.x * .6
	var angle_to_cursor = Actor_poz.angle()  
	SMen.Move_Anim(self,Vector2(distance, 0).rotated(angle_to_cursor),angle_to_cursor - PI/2, 0.5)
