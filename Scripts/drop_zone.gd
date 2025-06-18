extends Area2D
class_name DropZone

@export var hand_index := 1
@export var is_player_zone := true

var occupied := false
var occupying_card: Area2D = null

func _on_area_entered(area: Area2D) -> void:
	if area.name.begins_with("Card"):
		_clear_existing_slot(area.name)
		Globals.playerHand[hand_index]["card"] = area.name
		occupying_card = area

func _on_area_exited(area: Area2D) -> void:
	if area == occupying_card:
		if Globals.playerHand[hand_index]["card"] == area.name:
			Globals.playerHand[hand_index]["card"] = ""
		occupying_card = null

func _clear_existing_slot(card_name: String):
	for i in Globals.playerHand.keys():
		if Globals.playerHand[i]["card"] == card_name:
			Globals.playerHand[i]["card"] = ""
