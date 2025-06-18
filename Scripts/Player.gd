extends Node

const CROUPIER_PATH := "/root/Main/Croupier"
const GAME_MANAGER_PATH := "/root/Main/GameManager"

var shot: AudioStreamPlayer

func _on_button_pressed() -> void:
	if not Globals.playerTurn:
		return

	if Globals.current_chamber >= 6:
		print("Revolver is empty. Spin again to reload.")
		return

	var chamber_index = Globals.current_chamber
	var has_bullet = Globals.revolver_chambers[chamber_index]
	print("Firing chamber", chamber_index + 1, "- Bullet?", has_bullet)

	if has_bullet:
		Globals.playerHP -= 1
		get_node(GAME_MANAGER_PATH).reset_round()
	else:
		print("Click. Chamber was empty.")

	Globals.current_chamber += 1

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
	print("Player: Start")
	Globals.playerTurn = true
	Globals.playerPickedCard = false

	for child in get_children():
		if child is Area2D:
			child.input_pickable = true

	while Globals.playerTurn:
		await get_tree().process_frame

	print(Globals.playerHand)
	print("Player: Player is finished!")
	print(Globals.playerSum)

func _process(_delta: float) -> void:
	var total := 0
	var count := 0

	for card_name in Globals.playerHand:
		if card_name != "":
			count += 1
			if Globals.fullDeck.has(card_name):
				total += Globals.fullDeck[card_name]["value"]
			else:
				print("Card not found in fullDeck:", card_name)

	Globals.playerSum = total
	Globals.playerAmount = count

func _ready() -> void:
	pass
