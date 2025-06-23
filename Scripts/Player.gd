extends Node

const CROUPIER_PATH := "/root/Main/Croupier"
const GAME_MANAGER_PATH := "/root/Main/GameManager"

var shot: AudioStreamPlayer

func _on_button_pressed() -> void:
	if not Globals.turn == 1:
		return

	if Globals.current_chamber >= 6:
		print("Revolver is empty. Spin again to reload.")
		return

	var chamber_index = Globals.current_chamber
	var has_bullet = Globals.revolver_chambers[chamber_index]
	print("Firing chamber", chamber_index + 1, "- Bullet?", has_bullet)

	if has_bullet:
		Globals.playerHP -= 1
		Globals.spin_revolver()
	else:
		print("Click. Chamber was empty.")


func _on_game_manager_call_player() -> void:
	print("Player: Start")
	Globals.turn = 1
	while Globals.turn == 1:
		await get_tree().process_frame
	Globals.turn = 1
	print("Player: Player is finished!")

func _process(_delta: float) -> void:
	var total := 0
	var count := 0

	for card_name in Globals.playerHand:
		if card_name != "":
			count += 1
			if Globals.FULLDECK.has(card_name):
				total += Globals.FULLDECK[card_name][0]
			else:
				print("Card not found in fullDeck:", card_name)

	Globals.playerSum = total
	Globals.playerAmount = count

func _ready() -> void:
	pass
