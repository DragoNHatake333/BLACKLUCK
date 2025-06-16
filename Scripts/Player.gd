extends Node

const CROUPIER_PATH := "/root/Main/Croupier"
const GAME_MANAGER_PATH := "/root/Main/GameManager"

func _on_button_pressed() -> void:
	if not Globals.playerTurn:
		return

	print("Player: Revolver")

	_reset_croupier_scene()
	_reset_center_cards()

	get_node(GAME_MANAGER_PATH).callingCroupier()
	Globals.playerTurn = false


func _reset_croupier_scene() -> void:
	var croupier := get_node(CROUPIER_PATH)
	for child in croupier.get_children():
		child.queue_free()  # No need to check parent, get_children ensures this


func _reset_center_cards() -> void:
	Globals.centerCards = 0
	Globals.newcardGive.clear()

	# Using loop for scalability (e.g., 3 cards -> easily adjusted)
	Globals.centerHand.clear()
	for i in range(1, 4):
		Globals.centerHand[i] = {
			"placement": i + 5,  # Maps to 6, 7, 8
			"card": ""
		}


func _on_game_manager_call_player() -> void:
	Globals.playerTurn = true
	Globals.playerPickedCard = false

	for child in get_children():
		if child is Area2D:
			child.input_pickable = true

	print("Player: Start")

	while Globals.playerTurn:
		await get_tree().create_timer(1).timeout

	print("Player: Player is finished!")


func _process(_delta: float) -> void:
	pass  # Placeholder for frame-based logic if needed
