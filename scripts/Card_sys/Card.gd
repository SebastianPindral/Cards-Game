extends Node2D
class_name ONE_Card
@onready var front: Sprite2D = $Front
@onready var back: Sprite2D = $Back
#Color: Pik / Trefl / Kier / Karo
#Number: 2-10,J,Q,K,A,Joker
var ID = -1
var Data = {"Number":0,"Color":0}
var size = Vector2(100,150)
var state = ""

func Start(id0,N,C):
	face_Down()
	ID = id0
	Data["Number"] = N
	Data["Color"] = C
	$Creator.Create(N,C)

func where_is(isin):
	state = isin

func face_Down():
	front.visible = false
	back.visible = true


func face_Up():
	front.visible = true
	back.visible = false
