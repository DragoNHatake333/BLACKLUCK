extends Node

var shuffled_deck: Array = []
var card_scene := preload("res://Scenes/Card.tscn")



func _on_game_manager_call_croupier() -> void:
	Globals.croupierTurn = true
	print("Croupier: Start")

	_randomize_deck()
	_prepare_center_cards()
	_display_center_cards()
	_remove_used_cards_from_deck()

	print("Croupier: Done")
	Globals.croupierTurn = false

func _randomize_deck() -> void:
	shuffled_deck = Globals.cardDict.keys()
	shuffled_deck.shuffle()

func _prepare_center_cards() -> void:
	Globals.centerGive = max(0, 3 - Globals.centerCards)
	Globals.newcardGive.clear()
	var dealt_count = 0
	var sorted_keys = Globals.centerHand.keys()
	sorted_keys.sort()
	for key in sorted_keys:
		if dealt_count >= Globals.centerGive:
			break
		if Globals.centerHand[key]["card"] == "":
			var card_name = shuffled_deck[dealt_count]
			Globals.centerHand[key]["card"] = card_name
			Globals.newcardGive.append(card_name)
			dealt_count += 1

func _display_center_cards() -> void:
	for key in Globals.centerHand:
		var card_name = Globals.centerHand[key]["card"]
		if card_name in Globals.cardDict:
			var card = card_scene.instantiate()
			card.name = card_name
			card.get_node("CardSprite").texture = load(Globals.cardDict[card_name]["image_path"])
			card.scale = Vector2(0.38, 0.38)
			if key in Globals.positions_dict:
				var pos = Globals.positions_dict[key]
				card.position = Vector2(pos["posx"], pos["posy"])
			add_child(card)


func _remove_used_cards_from_deck() -> void:
	for card_name in Globals.newcardGive:
		Globals.cardDict.erase(card_name)
