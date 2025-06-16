extends Area2D

var occupied := false
var occupying_card: Area2D = null

func get_card_name() -> String:
	if occupying_card:
		return occupying_card.name
	return ""

func get_card_value() -> int:
	var card_name = get_card_name()
	if card_name != "" and Globals.cardDict.has(card_name):
		return Globals.cardDict[card_name]["value"]
	return 0
