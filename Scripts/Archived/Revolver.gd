extends Node

signal drawCards
signal sound_noBullet
signal sound_revolverShot
signal sound_revolverSpin

func _on_pressed():
	if Globals.playerRevolverPressed == false:
		if Globals.playerTurn == true:
			Globals.playerRevolverPressed = true
			if Globals.revolver_chambers[Globals.current_chamber]:
				sound_noBullet.emit()
				Globals.spin_revolver()
				sound_revolverSpin.emit()
				Globals.cards_in_center_hand = 0
				for child in $"../CardManager".get_children():
					if child.name not in Globals.playerHand and child.name not in Globals.aiHand:
						remove_child(child)
						child.queue_free()
				Globals.centerHand = []
				Globals.playerShootHimself = true
				Globals.playerAmount = 5
				Globals.aiSum = 1
				Globals.playerSum = 0
				Globals.aiAmount = 5
				Globals.saveRound = true
				Globals.playerTurn = false
			else:
				sound_noBullet.emit()
				Globals.cards_in_center_hand = 0
				for child in $"../CardManager".get_children():
					if child.name not in Globals.playerHand and child.name not in Globals.aiHand:
						$"../CardManager".remove_child(child)
						child.queue_free()
				Globals.centerHand = []
				Globals.current_chamber += 1
				emit_signal("drawCards")
		else:
			return
