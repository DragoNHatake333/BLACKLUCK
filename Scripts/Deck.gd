extends Node2D

const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
const CARD_DRAW_SPEED = 0.5
const cards_that_shoud_be_in_center = 3
var cards_to_deal = 0

var centerDeck = [
	"ace_of_clubs", "2_of_clubs", "3_of_clubs", "4_of_clubs", "5_of_clubs", "6_of_clubs", "7_of_clubs", "8_of_clubs", "9_of_clubs", "10_of_clubs",
	"jack_of_clubs", "queen_of_clubs", "king_of_clubs",

	"ace_of_diamonds", "2_of_diamonds", "3_of_diamonds", "4_of_diamonds", "5_of_diamonds", "6_of_diamonds", "7_of_diamonds", "8_of_diamonds", "9_of_diamonds", "10_of_diamonds",
	"jack_of_diamonds", "queen_of_diamonds", "king_of_diamonds",

	"ace_of_hearts", "2_of_hearts", "3_of_hearts", "4_of_hearts", "5_of_hearts", "6_of_hearts", "7_of_hearts", "8_of_hearts", "9_of_hearts", "10_of_hearts",
	"jack_of_hearts", "queen_of_hearts", "king_of_hearts",

	"ace_of_spades", "2_of_spades", "3_of_spades", "4_of_spades", "5_of_spades", "6_of_spades", "7_of_spades", "8_of_spades", "9_of_spades", "10_of_spades",
	"jack_of_spades", "queen_of_spades", "king_of_spades"
]

func _on_game_manager_call_deck() -> void:
	print("Deck called!")
	centerDeck.shuffle()
	if Globals.cards_in_center_hand != cards_that_shoud_be_in_center:
		cards_to_deal = cards_that_shoud_be_in_center - Globals.cards_in_center_hand
		draw_card(cards_to_deal)


func _ready() -> void:
	$RichTextLabel.text = str(centerDeck.size())

func draw_card(reps):
	for i in reps:
		Globals.cards_in_center_hand += 1
		print(Globals.cards_in_center_hand)
		var card_drawn_name = centerDeck[0]
		centerDeck.erase(card_drawn_name)
		
		if centerDeck.size() == 0:
			$Area2D/CollisionShape2D.disabled = true
			$Sprite2D.visible = false
			$RichTextLabel.visible = false
			
		$RichTextLabel.text = str(centerDeck.size())
		var card_scene = preload(CARD_SCENE_PATH)
		var new_card = card_scene.instantiate()
		var card_image_path = str("res://Cards/"+card_drawn_name+".png")
		new_card.get_node("CardImage").texture = load(card_image_path)
		$"../CardManager".add_child(new_card)
		new_card.name = card_drawn_name
		$"../CenterHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
