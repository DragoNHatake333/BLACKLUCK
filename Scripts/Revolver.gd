extends Node

signal revolverCallDeck

func _on_pressed() -> void:
	#if not Globals.playerTurn:
	#	return

	if Globals.current_chamber >= 6:
		print("Revolver: Empty. Spin again to reload.")
		return

	print("Revolver: Firing chamber ", Globals.current_chamber + 1, " - Bullet: ", Globals.revolver_chambers[Globals.current_chamber])
	if Globals.revolver_chambers[Globals.current_chamber]:
		Globals.playerHP -= 1
		Globals.spin_revolver()
		Globals.cards_in_center_hand = 0
		for child in $"../CardManager".get_children():
			if child.name not in Globals.playerHand or Globals.aiHand:
				remove_child(child)
				child.queue_free()
		Globals.centerHand = []
		emit_signal("revolverCallDeck")
		
	else:
		print("Revolver: Chamber was empty.")
		Globals.current_chamber += 1
