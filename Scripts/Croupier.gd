extends Node

var shuffledDeck = []

func _on_game_manager_call_croupier() -> void:
	Globals.croupierTurn = true
	print("Croupier: Start")

	# Refill deck if it's low
	if Globals.cardDict.size() < 2:
		print("Croupier: Deck is empty. Resetting...")
		Globals.cardDict = Globals.fullDeck.duplicate(true)

	# Shuffle deck
	_randomize_deck()

	# Determine how many cards to deal to center
	Globals.centerGive = max(0, (Globals.centerCards - 3) * -1)
	Globals.newcardGive.clear()

	# Pick cards from deck
	_deal_new_cards_to_center()

	# Render the cards visually
	_display_center_cards()

	# Remove dealt cards from deck
	_remove_used_cards_from_deck()

	print("Croupier: Done")
	Globals.croupierTurn = false


# --- Helper Functions ---

func _randomize_deck() -> void:
	print("Croupier: Shuffling deck...")
	shuffledDeck = Globals.cardDict.keys()
	shuffledDeck.shuffle()


func _deal_new_cards_to_center() -> void:
	for i in range(Globals.centerGive):
		Globals.newcardGive.append(shuffledDeck[i])

	var idx = 1
	for card_name in Globals.newcardGive:
		while idx <= 3:
			if Globals.centerHand.has(idx) and Globals.centerHand[idx]["card"] == "":
				Globals.centerHand[idx]["card"] = card_name
				idx += 1
				break
			idx += 1


func _display_center_cards() -> void:
	for key in Globals.centerHand:
		var card_name = Globals.centerHand[key]["card"]
		if card_name in Globals.cardDict:
			var sprite = Sprite2D.new()
			sprite.texture = load(Globals.cardDict[card_name]["image_path"])
			sprite.scale = Vector2(0.38, 0.38)

			var adjust_key = key + 6
			if adjust_key in Globals.positions_dict:
				var pos = Globals.positions_dict[adjust_key]
				sprite.position = Vector2(pos["posx"], pos["posy"])
			add_child(sprite)


func _remove_used_cards_from_deck() -> void:
	for key in Globals.centerHand.keys():
		var card_name = Globals.centerHand[key]["card"]
		if card_name != "":
			Globals.cardDict.erase(card_name)
