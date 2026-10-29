extends Node2D
class_name ONE_Card
@onready var front: Sprite2D = $Front
@onready var back: Sprite2D = $Back
#Color: Pik / Trefl / Kier / Karo
#Number: 2-10,J,Q,K,A,Joker
var Data = {"Number":0,"Color":0}
var fliped = false

func Start(N,C):
	face_Down()
	Data["Number"] = N
	Data["Color"] = C
	$Creator.Create(N,C)

func face_Down():
	front.visible = false
	back.visible = true

func face_Up():
	front.visible = true
	back.visible = false
