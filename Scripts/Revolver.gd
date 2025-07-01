extends Node

signal revolverCallDeck
var shooter = null

func _on_pressed() -> void:
	#if not Globals.playerTurn:
		#return

	if Globals.current_chamber >= 6:
		print("Revolver: Empty. Spin again to reload.")
		return

	print("Revolver: Firing chamber ", Globals.current_chamber + 1, " - Bullet: ", Globals.revolver_chambers[Globals.current_chamber])
	if Globals.revolver_chambers[Globals.current_chamber]:
		if shooter == null:
			Globals.playerHP -= 1
			Globals.playerTurn = false
		else:
			Globals.aiHP -= 1
			Globals.aiTurn = false
		Globals.spin_revolver()
		Globals.cards_in_center_hand = 0
		for child in $"../CardManager".get_children():
			if child.name not in Globals.playerHand and child.name not in Globals.aiHand:
				remove_child(child)
				child.queue_free()
		Globals.centerHand = []
		
	else:
		Globals.cards_in_center_hand = 0
		for child in $"../CardManager".get_children():
			if child.name not in Globals.playerHand and child.name not in Globals.aiHand:
				print("Child name: ", child.name)
				print("playerHand: ", Globals.playerHand)
				print("aiHand:", Globals.aiHand)
				print("centerHand:", Globals.centerHand )
				remove_child(child)
				child.queue_free()
		Globals.centerHand = []
		print("Revolver: Chamber was empty.")
		Globals.current_chamber += 1
		Globals.aiWaitingRevolver = false

func _on_ai_ai_revolver() -> void:
	shooter = false
	_on_pressed()
	shooter = null
