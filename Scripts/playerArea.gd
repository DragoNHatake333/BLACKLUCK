extends Area2D

func _on_area_entered(area: Area2D) -> void:
		if not Globals.playerHand.has(area.name):
			Globals.playerHand.append(area.name)
			print("Card added to player hand:", area.name)

func is_player_hand_area() -> bool:
	return true
