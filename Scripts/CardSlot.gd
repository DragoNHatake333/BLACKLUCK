extends Node2D

class_name CardSlot

var card_in_slot = false
@export var Who_Owns = true
var card_name
var card_added = false 

func _process(_delta: float) -> void:
	if card_in_slot and not card_added and card_name != null and card_name in Globals.deck:
		card_added = true
		#var card_value = Globals.deck[card_name][0]
		if Who_Owns:
			Globals.playerHand.append((str(card_name)))
			Globals.playerTurn = false
			Globals.aiTurn = false
		else:
			Globals.aiHand.append((str(card_name)))
			Globals.aiTurn = false
			Globals.playerTurn = false
		Globals.cards_in_center_hand -= 1


func _on_game_manager_reset_card_slots() -> void:
	card_name = null
	card_added = null
	card_in_slot = null
