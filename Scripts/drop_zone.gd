extends Area2D
class_name DropZone  # Makes it usable with `as DropZone`

var occupied: bool = false
var occupying_card: Area2D = null
@export var hand_index := 1  # If you're tracking hand slots


func _on_area_entered(area: Area2D) -> void:
	if not area.name.begins_with("Card"):
		return

	# Remove this card from any other slots
	for i in Globals.playerHand.keys():
		if Globals.playerHand[i]["card"] == area.name:
			Globals.playerHand[i]["card"] = ""
			print("Removed", area.name, "from slot", i)

	# Assign this card to the current hand slot
	Globals.playerHand[hand_index]["card"] = area.name
	occupying_card = area
	print("Assigned", area.name, "to slot", hand_index)


func _on_area_exited(area: Area2D) -> void:
	# If card exits this zone, and it's the one occupying it, clear it
	if area == occupying_card:
		print("Card", area.name, "left slot", hand_index)
		if Globals.playerHand[hand_index]["card"] == area.name:
			Globals.playerHand[hand_index]["card"] = ""
		occupying_card = null
