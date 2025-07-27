extends Node

func _on_game_manager_call_player() -> void:
	Globals.playerRevolverPressed = false
	pass

func _on_game_manager_call_count_amount() -> void:
	var total := 0
	var count := 0

	for card_name in Globals.playerHand:
		if card_name != "":
			count += 1
			if Globals.FULLDECK.has(card_name):
				total += Globals.FULLDECK[card_name][0]
			else:
				print("Card not found in fullDeck:", card_name)

	Globals.playerSum = total
	Globals.playerAmount = count
