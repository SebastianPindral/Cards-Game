extends Sprite2D

var direct = 1
func _ready():
	var target_size = Vector2(310,310)
	var tex_size = texture.get_size()
	scale = target_size / tex_size
	spin()

func spin():
	var tween = create_tween()
	tween.tween_property(self, "rotation", rotation - direct*TAU, 10.0)  # 360° w 1 sek
	tween.tween_callback(Callable(self, "spin"))

func Re_Direct():
	flip_h = not flip_h
	direct *= -1
	spin()
