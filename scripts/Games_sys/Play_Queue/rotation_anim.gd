extends Sprite2D
var self_size = Vector2(310,310)
var direct = 1
func _ready():
	add_to_group("spin")
	SMen.Resize(self,self_size)
	z_index = -4090

func Re_Direct():
	flip_h = not flip_h
	direct *= -1
