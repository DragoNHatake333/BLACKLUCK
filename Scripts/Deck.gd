extends Node2D

const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
const CARD_DRAW_SPEED = 0.5
const cards_that_shoud_be_in_center = 3
var cards_to_deal = 0

func _on_game_manager_call_deck() -> void:
	print("Deck: Deck called!")
	Globals.centerDeck.shuffle()
	
	if Globals.cards_in_center_hand < cards_that_shoud_be_in_center:
		cards_to_deal = cards_that_shoud_be_in_center - Globals.cards_in_center_hand
		draw_card(cards_to_deal)
	else:
		print("Deck: Center hand already has enough cards, no more dealt.")
	
	Globals.deckTurn = false

func _ready() -> void:
	$RichTextLabel.text = str(Globals.centerDeck.size())

func draw_card(reps):
	for i in reps:
		if Globals.centerDeck.size() == 0:
			Globals.centerDeck = Globals.fullCenterDeck
		Globals.cards_in_center_hand += 1
		var card_drawn_name = Globals.centerDeck[0]
		Globals.centerDeck.erase(card_drawn_name)
		$RichTextLabel.text = str(Globals.centerDeck.size())
		var card_scene = preload(CARD_SCENE_PATH)
		var new_card = card_scene.instantiate()
		var card_image_path = str("res://Cards/"+card_drawn_name+".png")
		new_card.get_node("CardImage").texture = load(card_image_path)
		$"../CardManager".add_child(new_card)
		new_card.name = card_drawn_name
		$"../CenterHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
