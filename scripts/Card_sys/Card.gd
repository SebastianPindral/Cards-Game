extends Node2D
class_name ONE_Card
@onready var front: Sprite2D = $Front
@onready var back: Sprite2D = $Back

signal Used()
signal Holdered(arg)

var shadow_position
var Data = {"Number":0,"Color":0}
var size = Vector2(100,150)

var is_hold = [false,false] #0-hard_hold NIE zmienia sie przez najechanie / 1-low_hold zmienia sie przez najechanie
var state = ""
var legality = true

func Start(N,C):
	face_Down()
	Data["Number"] = N
	Data["Color"] = C
	$Creator.Create(N,C)

func where_is(isin,target_poz):
	state = isin
	if isin == "player":
		face_Up()
	elif isin == "Discard":
		face_Up()
	elif isin == "host" or isin == "Stack":
		face_Down()
	
	shadow_position = target_poz

func legal(bol):
	legality = bol
	if bol:
		if is_hold[0]:
			front.modulate = Color(.3,1,.3)
		else:
			front.modulate = Color(1,1,1)
	else:	front.modulate = Color(.3,.3,.3)

func face_Down():
	front.visible = false
	back.visible = true

func face_Up():
	front.visible = true
	back.visible = false

func reset():
	$Area2D.position = Vector2(0,0)
	$Area2D/CollisionShape2D.shape.size = size

	is_hold[0] = false
	legal(true)

func Use():
	reset()
	Used.emit()

func holder():
	if legality:
		is_hold[0] = not is_hold[0]
		if is_hold[0]:
			front.modulate = Color(.3,1,.3)
		else:
			front.modulate = Color(1,1,1)
		
		Holdered.emit(self)
