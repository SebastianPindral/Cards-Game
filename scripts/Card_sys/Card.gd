extends Node2D
class_name ONE_Card
@onready var front: Sprite2D = $Front
@onready var back: Sprite2D = $Back

signal Used()
var shadow_position
var Data = {"Number":0,"Color":0}
var size = Vector2(100,150)
var state = ""

func Start(N,C):
	face_Down()
	Data["Number"] = N
	Data["Color"] = C
	$Creator.Create(N,C)

func where_is(isin,target_poz):
	state = isin
	if isin == "player" or isin == "Discard":
		face_Up()
	elif isin == "host":
		face_Down()
	shadow_position = target_poz

func face_Down():
	front.visible = false
	back.visible = true

func face_Up():
	front.visible = true
	back.visible = false

func Use():
	$Area2D.position = Vector2(0,0)
	Used.emit()
