extends VBoxContainer
const SCORE_STATE = preload("res://Prefabs/UI/Score_State.tscn")

func _ready() -> void:
	position = Vector2(1600,50)
	await GM.players
	create_board()

func create_board():
	var counter = GM.Game.player_count if not GM.Game.ch("MT") else GM.Game.player_count/2
	for i in counter:
		var name_text = str(GM.Players[i][0].typ) + str(GM.Players[i][0].numer) if not GM.Game.ch("MT") else "Team "+str(i+1)
		var obj = SCORE_STATE.instantiate()
		obj.get_child(0).get_child(0).text = name_text
		obj.get_child(0).get_child(1).text = str(0)
		add_child(obj)

func Data_update(data:Array):
	var i = 0
	for o in get_children():
		o.get_child(0).get_child(1).text = str(data[i])
		i += 1
