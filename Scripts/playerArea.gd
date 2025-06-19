extends Area2D

func _on_area_entered(area: Area2D) -> void:
	Globals.playerHand.append(area.name)
	Globals.card_in_area = true
	Globals.playerTurn = false

func _on_area_exited(area: Area2D) -> void:
	Globals.playerHand.erase(area.name)
