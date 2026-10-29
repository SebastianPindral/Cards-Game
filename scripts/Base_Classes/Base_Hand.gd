extends Node2D

class_name Base_Hand
var On_Hand = []
var numer
func set_this(typ,num=0):
	var HostHand = load("res://scripts/Players/Host_hand.gd")
	var PlayerHand = load("res://scripts/Players/Player_hand.gd")
	match typ:
		"player":
			set_script(PlayerHand)
		"host":
			set_script(HostHand)
			numer = num

func take_cards(cards:Array):
	for c in cards:
		On_Hand.append(c)
	set_visual()

func set_visual():pass
