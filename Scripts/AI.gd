extends Node

func _on_game_manager_call_ai() -> void:
	Globals.turn = 2
	print("AI: Start.")
	
	print("AI: Done.")


func _process(_delta: float) -> void:
	var total := 0
	var count := 0

	for card_name in Globals.aiHand:
		if card_name != "":
			count += 1
			if Globals.FULLDECK.has(card_name):
				total += Globals.FULLDECK[card_name][0]
			else:
				print("Card not found in fullDeck:", card_name)

	Globals.aiSum = total
	Globals.aiAmount = count
