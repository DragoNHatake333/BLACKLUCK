extends Node2D

const HAND_COUNT = 3
const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
const CARD_WIDTH = 300

var center_screen_x
var center_screen_y

func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2
	center_screen_y = get_viewport().size.y / 2
	
	var card_scene = preload(CARD_SCENE_PATH)
	for i in range(HAND_COUNT):
		var new_card = card_scene.instantiate()
		$"../CardManager".add_child(new_card)
		new_card.name = "Card"
		add_card_to_hand(new_card)
		
func add_card_to_hand(card):
	if card not in Globals.centerHand:
		Globals.centerHand.insert(0, card)
		update_hand_positions()
	else:
		animate_card_to_position(card, card.position_in_hand)


func update_hand_positions():
	for i in range(Globals.centerHand.size()):
		var new_position = Vector2(calculate_card_position(i), center_screen_y)
		var card = Globals.centerHand[i]
		card.position_in_hand = new_position
		animate_card_to_position(card, new_position)
		
func calculate_card_position(index):
	var total_width = (Globals.centerHand.size() -1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset

func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)

func remove_card_from_hand(card):
	if card in Globals.centerHand:
		Globals.centerHand.erase(card)
		update_hand_positions()
