extends Node

var filteredCenterHand = {}
var selectedCard = []
var checking_center_cards = false
var selected_index = null
var to_player_slot = false
signal aiRevolver

func _on_game_manager_call_ai() -> void:
	print("AI: Start!")
	filteredCenterHand = {}
	selectedCard = []
	checking_center_cards = false
	selected_index = null
	to_player_slot = false
	
	var selected_card_node = null
	checking_center_cards = true
	check_center_cards()
	while checking_center_cards == true:
		await get_tree().process_frame
	
	await get_tree().create_timer(randi_range(1,2)).timeout
	
	for card_name in filteredCenterHand:
		var card_value = filteredCenterHand[card_name]
		if card_value >= 10:
			selectedCard.append(card_name)
			to_player_slot = false
			break
		if card_value <= 4:
			selectedCard.append(card_name)
			to_player_slot = true
			break
		elif not card_value >= 10 or card_value <= 4:
			Globals.aiWaitingRevolver = true
			ai_calling_revolver()
			while Globals.aiWaitingRevolver == true:
				await get_tree().process_frame
	
	if selectedCard:
		for i in Globals.centerHand.size():
			var card = Globals.centerHand[i]
			if str(card.name) == selectedCard[0]:
				selected_card_node = card
				selected_index = i
				break
	else:
		print("No card was selected!")

	var free_slots = []
	if Globals.playerAmount == 5:
		for i in $"../iaHand".get_children():
			if i.get("card_in_slot") == false:
				free_slots.append(i)
	elif Globals.aiAmount == 5:
		for i in $"../playerHand".get_children():
			if i.get("card_in_slot") == false:
				free_slots.append(i)
	elif to_player_slot == false:
		for i in $"../iaHand".get_children():
			if i.get("card_in_slot") == false:
				free_slots.append(i)
	elif to_player_slot == true:
		for i in $"../playerHand".get_children():
			if i.get("card_in_slot") == false:
				free_slots.append(i)


	if free_slots.size() > 0 and selected_card_node:
		var chosen_slot = free_slots[randi() % free_slots.size()]
		var slot_position = chosen_slot.global_position

		chosen_slot.card_in_slot = true
		selected_card_node.get_node("Area2D/CollisionShape2D").disabled = true
		var tween = get_tree().create_tween()
		selected_card_node.z_index = 4
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_QUART)
		tween.tween_property(selected_card_node, "position", slot_position, randf_range(0.3,1))
		

		Globals.centerHand.remove_at(selected_index)
		Globals.aiHand.append(selectedCard[0])
		Globals.cards_in_center_hand -= 1
	else:
		print("No free slots available or selected card not found.")

	print("AI: Finished!")
	Globals.aiTurn = false

func check_center_cards():
	for card in Globals.centerHand:
		var card_name := str(card.name)
		var card_data = Globals.deck.get(card_name)
		if card_data:
			var card_value = card_data[0]
			filteredCenterHand[card_name] = card_value
		else:
			print("Card data not found for:", card_name)

	checking_center_cards = false

func ai_calling_revolver():
	print("Revolver logic called.")
	emit_signal("aiRevolver")

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
