extends Node2D

const CARD_WIDTH = 290.0
const DEFAULT_CARD_MOVE_SPEED = 0.1

var center_screen_x
var center_screen_y

func add_card_to_hand(card, speed):
	if card not in Globals.centerHand:
		Globals.centerHand.insert(0, card)
		update_hand_positions(speed)
	else:
		animate_card_to_position(card, card.position_in_hand, DEFAULT_CARD_MOVE_SPEED)

func update_hand_positions(speed):
	for i in range(Globals.centerHand.size()):
		center_screen_y = get_viewport_rect().size.y / 2
		var new_position = Vector2(calculate_card_position(i), center_screen_y)
		var card = Globals.centerHand[i]
		card.position_in_hand = new_position
		animate_card_to_position(card, new_position, speed)
		
func calculate_card_position(index):
	var total_width = (Globals.centerHand.size() -1) * CARD_WIDTH
	var x_offset = (get_viewport_rect().size.x / 2.0) + index * CARD_WIDTH - total_width / 2.0
	return x_offset

func animate_card_to_position(card, new_position, speed):
	card.z_index = 4
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(card, "position", new_position, speed)
	card.z_index = 1

func remove_card_from_hand(card):
	if card in Globals.centerHand:
		Globals.centerHand.erase(card)
		update_hand_positions(DEFAULT_CARD_MOVE_SPEED)
