extends Node

var filteredCenterHand = {}
var selectedCard = []
var checking_center_cards = false
var selected_index = null
var to_player_slot = false
var revolverPressed = false
var checking_hl_cards
var highestCard
var lowestCard
signal drawCards
var card1Value
var card1Name
var card2Value
var card2Name
var card3Value
var card3Name
var selected_card_node
signal callSoundManager(sound)

func _on_game_manager_call_ai() -> void:
	print("AI: Start!")
	await get_tree().create_timer(randf_range(1.0, 3.0)).timeout
	print(Globals.current_chamber)
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
	
	#Checking highest and lowest card.
	checking_hl_cards = true
	check_hl_cards()
	while checking_hl_cards == true:
		await get_tree().process_frame
	
	#Does someone have 5 cards?
	if Globals.playerAmount == 5 or Globals.aiAmount == 5:
		if Globals.playerAmount == 5 and Globals.aiAmount == 4:
			if (highestCard["value"] + Globals.aiSum) > Globals.playerSum:
				give_card("ai", highestCard["name"])
				return
			elif not (highestCard["value"] + Globals.aiSum) > Globals.playerSum and revolverPressed == false:
				call_revolver()
				return
			else:
				normal_play()
				return
		elif Globals.playerAmount == 4 and Globals.aiAmount == 5:		
			if not (lowestCard["value"] + Globals.playerSum) > Globals.aiSum:
				give_card("ai", highestCard["name"])
				return
			elif (lowestCard["value"] + Globals.playerSum) > Globals.aiSum and revolverPressed == false:
				call_revolver()
				return
			else:
				normal_play()
				return
		else:
			if Globals.playerAmount == 5:
				if highestCard["value"] <= 5:
					if Globals.current_chamber >= 3:
						give_card("ai", highestCard["name"])
						return
					elif revolverPressed == false:
						call_revolver()
						return
					else:
						give_card("ai", highestCard["name"])
			elif Globals.aiAmount == 5:
				if lowestCard["value"] >= 8:
					if Globals.current_chamber >= 3:
						give_card("player", lowestCard["name"])
						return
					elif revolverPressed == false:
						call_revolver()
						return
					else:
						give_card("player", lowestCard["name"])
						
			#HERE GOES NEW THINGAAAAAAAAAA ALSO JOT DOWN IN FIGMA A FLOW YOU WILL REMEMBER
	
	normal_play()
			
func normal_play():
	if lowestCard["value"] == 1:
		give_card("player", lowestCard["name"])
	elif highestCard["value"] == 13:
		give_card("ai", highestCard["name"])
	elif lowestCard["value"] >= 4 and highestCard["value"] <= 6:
		if Globals.current_chamber <= 3 and revolverPressed == false:
			call_revolver()
			return
		else:
			pass
	else:
		if lowestCard["value"] > (highestCard["value"] - 13):
			give_card("player", lowestCard["name"])
		else:
			give_card("ai", highestCard["name"])

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

func check_hl_cards():
	var searching = 1
	for card_name in filteredCenterHand:
		var card_value = filteredCenterHand[card_name]
		if searching == 1:
			card1Value = card_value
			card1Name = card_name
		if searching == 2:
			card2Value = card_value
			card2Name = card_name
		if searching == 3:
			card3Value = card_value
			card3Name = card_name
		searching += 1
	var cards = [
	{"name": card1Name, "value": card1Value},
	{"name": card2Name, "value": card2Value},
	{"name": card3Name, "value": card3Value},
	]
	var highest_card = cards[0]
	var lowest_card = cards[0]
	for card in cards:
		if card["value"] > highest_card["value"]:
			highest_card = card
		if card["value"] < lowest_card["value"]:
			lowest_card = card
	highestCard = highest_card
	lowestCard = lowest_card
	
	checking_hl_cards = false
	
func give_card(who, which):
	for i in Globals.centerHand.size():
		var card = Globals.centerHand[i]
		if str(card.name) == which:
			selected_card_node = card
			selected_index = i
			break

	var free_slots = []
	if who == "ai":
		for i in $"../iaHand".get_children():
			if i.get("card_in_slot") == false:
				free_slots.append(i)
	if who == "player":
		for i in $"../playerHand".get_children():
			if i.get("card_in_slot") == false:
				free_slots.append(i)
	

	if free_slots.size() == 0:
		if who == "ai":
			give_card("player", lowestCard["name"])
			return
		elif who == "player":
			give_card("ai", highestCard["name"])
			return
	
	var chosen_slot = free_slots[randi() % free_slots.size()]
	var slot_position = chosen_slot.global_position
	
	chosen_slot.card_in_slot = true
	selected_card_node.get_node("Area2D/CollisionShape2D").disabled = true
	var tween = get_tree().create_tween()
	selected_card_node.z_index = 4
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(selected_card_node, "position", slot_position, randf_range(0.3,1))
	await tween.finished

	print(selectedCard)
	
	Globals.centerHand.remove_at(selected_index)
	if who == "player":
		Globals.playerHand.append(which)
	elif who == "ai":
		Globals.aiHand.append(which)
	Globals.cards_in_center_hand -= 1
	
	await get_tree().create_timer(0.5).timeout
	
	print("AI: Finished!")
	Globals.aiTurn = false
	revolverPressed = false
	
func call_revolver():
	print("AI: Revolver!")
	if revolverPressed == false:
		if Globals.aiTurn == true:
			if Globals.revolver_chambers[Globals.current_chamber]:
				callSoundManager.emit("yesBullet")
				Globals.spin_revolver()
				callSoundManager.emit("revolverSpin")
				var card_manager = $"../CardManager"
				for child in card_manager.get_children():
					if not (child.name in Globals.playerHand or child.name in Globals.aiHand):
						child.queue_free()
				Globals.centerHand.clear()
				Globals.aiShootHimself = true
				Globals.playerAmount = 5
				Globals.aiSum = 0
				Globals.playerSum = 1
				Globals.aiAmount = 5
				Globals.saveRound = true
				Globals.aiTurn = false
			else:
				callSoundManager.emit("noBullet")
				Globals.cards_in_center_hand = 0
				for child in $"../CardManager".get_children():
					if child.name not in Globals.playerHand and child.name not in Globals.aiHand:
						$"../CardManager".remove_child(child)
						child.queue_free()
				Globals.centerHand = []
				Globals.current_chamber += 1
				emit_signal("drawCards")
				_on_game_manager_call_ai()
				revolverPressed = true
		else:
			return

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
