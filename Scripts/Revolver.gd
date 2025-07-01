extends Node

signal drawCards
signal playerShootHimself
@onready var noBullet = $"../Sounds/noBullet"
@onready var yesBullet = $"../Sounds/yesBullet"
@onready var revolverSpin = $"../Sounds/revolverSpin"
#func _on_pressed() -> void:
	##if not Globals.playerTurn:
		##return
#
	#if Globals.current_chamber >= 6:
		#print("Revolver: Empty. Spin again to reload.")
		#return
#
	#print("Revolver: Firing chamber ", Globals.current_chamber + 1, " - Bullet: ", Globals.revolver_chambers[Globals.current_chamber])
	#if Globals.revolver_chambers[Globals.current_chamber]:
		#if shooter == null:
			#Globals.playerHP -= 1
			#Globals.playerTurn = false
		#else:
			#Globals.aiHP -= 1
			#Globals.aiTurn = false
		#Globals.spin_revolver()
		#Globals.cards_in_center_hand = 0
		#for child in $"../CardManager".get_children():
			#if child.name not in Globals.playerHand and child.name not in Globals.aiHand:
				#remove_child(child)
				#child.queue_free()
		#Globals.centerHand = []
		#
	#else:
		#Globals.cards_in_center_hand = 0
		#for child in $"../CardManager".get_children():
			#if child.name not in Globals.playerHand and child.name not in Globals.aiHand:
				#print("Child name: ", child.name)
				#print("playerHand: ", Globals.playerHand)
				#print("aiHand:", Globals.aiHand)
				#print("centerHand:", Globals.centerHand )
				#remove_child(child)
				#child.queue_free()
		#Globals.centerHand = []
		#print("Revolver: Chamber was empty.")
		#Globals.current_chamber += 1
		#Globals.aiWaitingRevolver = false

func _on_pressed():
	if Globals.playerRevolverPressed == false:
		if Globals.playerTurn == true:
			Globals.playerRevolverPressed = true
			if Globals.revolver_chambers[Globals.current_chamber]:
				yesBullet.play()
				await yesBullet.finished
				Globals.spin_revolver()
				revolverSpin.play()
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
				noBullet.play()
				Globals.cards_in_center_hand = 0
				for child in $"../CardManager".get_children():
					if child.name not in Globals.playerHand and child.name not in Globals.aiHand:
						remove_child(child)
						child.queue_free()
				Globals.centerHand = []
				Globals.current_chamber += 1
				emit_signal("drawCards")
		else:
			return
