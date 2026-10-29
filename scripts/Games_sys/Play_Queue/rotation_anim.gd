extends Sprite2D

var direct = 1
func _ready():
	SMen.Resize(self,Vector2(310,310))
	spin()

func spin():
	var tween = create_tween()
	tween.tween_property(self, "rotation", rotation - direct*TAU, 10.0)  # 360° w 1 sek
	tween.tween_callback(Callable(self, "spin"))

func Re_Direct():
	flip_h = not flip_h
	direct *= -1
	spin()
