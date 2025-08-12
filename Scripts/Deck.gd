extends Node2D

const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
const CARD_DRAW_SPEED = 0.5
const cards_that_shoud_be_in_center = 3
var cards_to_deal = 0
var drawing_cards = false
signal callSoundManager
func _ready() -> void:
	$RichTextLabel.text = str(Globals.centerDeck.size())

func _on_game_manager_call_deck() -> void:
	print("Deck: Deck called!")
	# Filter and shuffle before anything else
	Globals.centerDeck = Globals.fullCenterDeck.filter(func(card):
		return not $"../CardManager".has_node(card)
	)
	Globals.centerDeck.shuffle()

	if Globals.cards_in_center_hand < cards_that_shoud_be_in_center:
		cards_to_deal = cards_that_shoud_be_in_center - Globals.cards_in_center_hand
		drawing_cards = true
		draw_card(cards_to_deal)
		while drawing_cards:
			await get_tree().process_frame
	else:
		print("Deck: Center hand already has enough cards, no more dealt.")

	Globals.deckTurn = false

func draw_card(reps):
	print(Globals.centerDeck.size(), " AAAAAAAAAAAAAAAAAAAA")
	var drawn = 0

	while drawn < reps:
		# Re-filter if too few cards
		if Globals.centerDeck.size() <= 0:
			print("RESETTING CARDS!!!!!!!!!!!!!!!!")
			Globals.centerDeck = Globals.fullCenterDeck.filter(func(card):
				return not $"../CardManager".has_node(card)
			)
			Globals.centerDeck.shuffle()
			
			if Globals.centerDeck.size() == 0:
				push_error("No cards available to draw after filtering. All cards are in use!")
				break

		var card_drawn_name = Globals.centerDeck[0]
		Globals.centerDeck.erase(card_drawn_name)
		Globals.cards_in_center_hand += 1
		$RichTextLabel.text = str(Globals.centerDeck.size())

		var card_scene = preload(CARD_SCENE_PATH)
		var new_card = card_scene.instantiate()
		var card_image_path = "res://Cards2/" + card_drawn_name + ".png"
		new_card.get_node("CardImage").texture = load(card_image_path)
		new_card.name = card_drawn_name
		$"../CardManager".add_child(new_card)

		$"../CenterHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)

		drawn += 1

	drawing_cards = false
	emit_signal("callSoundManager", "deckDeal")
	var tween := create_tween()
	var center := get_viewport().get_visible_rect().size / 2
	tween.tween_property($"../SoundManager/deckDeal", "position", center, 0.3).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(1).timeout
	$"../SoundManager/deckDeal".position = Vector2(2077, 525)
