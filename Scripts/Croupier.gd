extends Node

var shuffledDeck = Globals.cardDict.keys()

func randomizeDict():
	print("Croupier: Shuffling deck...")
	shuffledDeck = Globals.cardDict.keys()  # Refresh the deck from current available cards
	shuffledDeck.shuffle()
func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	pass

func _on_game_manager_call_croupier() -> void:
	print("Croupier: Start")
	
	randomizeDict()
	
	Globals.centerGive = (Globals.centerCards - 3) * -1
	
	#Adding the amount of cards missing to the list newcardGive
	for i in range(Globals.centerGive):
		Globals.newcardGive.append(shuffledDeck[i])

	#Adding the values to the dictionary
	var idx = 1
	for i in Globals.newcardGive:
		while idx <= Globals.centerGive + 1 and idx<= 3:
			if Globals.centerHand[idx]["card"] == "":
				Globals.centerHand[idx]["card"] = i
				idx += 1
				break
			else:
				idx += 1
	print(Globals.centerHand)
	
	#Showing the cards
	for key in Globals.centerHand:
		var card_name = Globals.centerHand[key]["card"]
		if card_name in Globals.cardDict:
			var sprite = Sprite2D.new()
			sprite.texture = load(Globals.cardDict[card_name]["image_path"])
			
			var adjust_key = key + 6
			
			if key in Globals.positions_dict:
				var position = Globals.positions_dict[adjust_key]
				sprite.position = Vector2(position["posx"], position["posy"])
			sprite.scale = Vector2(0.38, 0.38)
			add_child(sprite)
	
	#Erasing the cards from cardDict
	for key in Globals.centerHand.keys():
		var card_key = Globals.centerHand[key]["card"]
		if card_key != "":
			Globals.cardDict.erase(card_key)
	
	Globals.croupierFinished = true
	print("Croupier: Done")
