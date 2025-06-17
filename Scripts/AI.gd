extends Node

func _aiDoesSomething() -> void:
	print("AI is thinking...")

	var think_time := randf_range(0.5, 2.0)  # Random delay between 0.5 to 2 seconds
	await get_tree().create_timer(think_time).timeout

	print("AI is choosing a card...")

	var ai_node := get_node("/root/Main/AI")
	var drop_zone_ai := get_node("/root/Main/drop_zone_ai")
	var croupier_node := get_node("/root/Main/Croupier")
	var available_zones := drop_zone_ai.get_children()
	var card_taken := false

	for center_key in Globals.centerHand:
		if card_taken:
			break

		var center_card_name: String = Globals.centerHand[center_key]["card"]
		if center_card_name != "":
			for hand_index in Globals.aiHand:
				if Globals.aiHand[hand_index]["card"] == "":
					var drop_zone := available_zones[hand_index - 1]
					if drop_zone.occupied:
						continue


					var card_node := croupier_node.get_node_or_null(center_card_name)
					if card_node:
						croupier_node.remove_child(card_node)
						ai_node.add_child(card_node)
						card_node.global_position = drop_zone.global_position
						card_node.z_index = 1

						drop_zone.occupied = true
						drop_zone.occupying_card = card_node

					Globals.aiHand[hand_index]["card"] = center_card_name
					Globals.centerHand[center_key]["card"] = ""
					card_taken = true
					break

	Globals.aiTurn = false
	print("AI hand:", Globals.aiHand)
	print("AI took a card.")

func _ready():
	randomize()

func _on_game_manager_call_ai() -> void:
	Globals.aiTurn = true
	print("AI: Start.")
	_aiDoesSomething()
	while Globals.aiTurn == true:
		await get_tree().process_frame
	print("AI: Done.")

func _process(_delta: float) -> void:
	var total := 0
	var count := 0

	for i in Globals.aiHand:
		var card_name = Globals.aiHand[i]["card"]
		if card_name != "":
			count += 1
			if Globals.fullDeck.has(card_name):
				total += Globals.fullDeck[card_name]["value"]

	Globals.iaSum = total
	Globals.aiAmount = count
