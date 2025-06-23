extends Node2D

var card_in_slot = false
@export var Who_Owns = true
var card_name
var card_added = false  # prevents duplicate adds

func _process(delta: float) -> void:
	if card_in_slot and not card_added and card_name != null and card_name in Globals.deck:
		var card_value = Globals.deck[card_name][0]
		if Who_Owns:
			Globals.playerHand.append(card_name)
		else:
			Globals.aiHand.append(card_name)
		Globals.cards_in_center_hand -= 1
		card_added = true
