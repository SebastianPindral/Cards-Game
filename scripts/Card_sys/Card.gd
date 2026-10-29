extends Node2D

class_name ONE_Card
#Color: Pik / Trefl / Kier / Karo
#Number: 2-10,J,Q,K,A,Joker
var Data = {"Number":0,"Color":0}

func Start(N,C):
	Data["Number"] = N
	Data["Color"] = C
	$Creator.Create(N,C)
