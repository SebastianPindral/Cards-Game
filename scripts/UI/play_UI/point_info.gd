extends Polygon2D
@onready var label: Label = $Label

var radius: float = 40.0
var points_count: int = 64

func _ready():
	z_index = -4095
	z_as_relative = false
	create_polygon(self,radius,Color.WHITE)
	var new = Polygon2D.new()
	create_polygon(new,radius*0.9,Color(0.3,0.3,0.3))
	add_child(new)
	move_child(label, get_child_count() - 1)
	label.position = Vector2(-radius*0.75,-radius)


func create_polygon(t:Polygon2D,radi:float,col):
	var pts = PackedVector2Array()
	for i in points_count:
		var angle = (float(i) / float(points_count)) * TAU
		pts.append(Vector2(cos(angle), sin(angle)) * radi)
	t.polygon = pts
	t.color = col
