extends Node

var filteredCenterHand = {}
var selectedCard := []
var checking_center_cards = false

func _on_game_manager_call_ai() -> void:
	print("AI: Start!")
	
	checking_center_cards = true
	check_center_cards()
	while checking_center_cards == true:
		await get_tree().process_frame
	
	await get_tree().create_timer(randi_range(1.0,6.0)).timeout
	
	for card_name in filteredCenterHand:
		var card_value = filteredCenterHand[card_name]
		if card_value >= 10 or card_value <= 4:
			selectedCard.append(card_name)
			break
		elif not card_value >= 10 or card_value <= 4:
			ai_calling_revolver()
			print("Calling")
	
	if selectedCard:
		pass
	print(selectedCard)

func check_center_cards():
	for card in Globals.centerHand:
		var card_name := str(card.name)
		var card_data = Globals.deck.get(card_name)
		if card_data:
			var card_value = card_data[0]
			filteredCenterHand[card_name] = card_value

	checking_center_cards = false

func ai_calling_revolver():
	pass

func _on_game_manager_call_count_amount() -> void:
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
