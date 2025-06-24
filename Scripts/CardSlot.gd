extends Node2D

class_name CardSlot

var card_in_slot = false
@export var Who_Owns = true
var card_name
var card_added = false 
signal request_draw_cards

func _process(delta: float) -> void:
	if card_in_slot and not card_added and card_name != null and card_name in Globals.deck:
		card_added = true  # Move this line UP to prevent double execution
		var card_value = Globals.deck[card_name][0]
		if Who_Owns:
			Globals.playerHand.append(card_name)
		else:
			Globals.aiHand.append(card_name)
		Globals.turn = 0
		Globals.cards_in_center_hand -= 1
		emit_signal("request_draw_cards")
