extends trick_taking
class_name Spades

# 4 lub 2 osob

func config_character(Data):
	player_count = Data["OCL_name_list"][0][1]
	Turn = player_count-1
	Atut = 1 # Pik
	color_blocked = 1


#func get_choise(Order_value,Order_type):
	#if Order.has(Order_type):
		#Order[Order_type] = [Turn,Order_value]
		#GM.table.get_node("Order_info").set_label(Order_type,Order_value)
		#sig_to_con.emit()
	#else:
		#print("Error - Order Makao")

#func Before_Throw(c):
	#if c.Data["Number"] == 11:#J
		#Obj_Order["Numbers"].visible = true
		#await sig_to_con
	#elif c.Data["Number"] == 14:#A
		#Obj_Order["Colors"].visible = true
		#await sig_to_con

func After_Trick(_win):
	pass
	#tutaj przypisac punkty wygranemu i dac mu rozpoczac kolejna kolejke

func After_loop():
	pass
