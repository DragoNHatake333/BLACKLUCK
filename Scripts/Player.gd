extends Node

const CROUPIER_PATH = "/root/Main/Croupier"
const GAME_MANAGER_PATH = "/root/Main/GameManager"

func _on_button_pressed() -> void:
	if not Globals.playerTurn:
		return

	print("Player: Revolver")

	_reset_croupier_scene()
	_reset_center_cards()
	
	get_node(GAME_MANAGER_PATH).callingCroupier()
	Globals.playerTurn = false


func _reset_croupier_scene() -> void:
	var croupier_node = get_node(CROUPIER_PATH)
	for child in croupier_node.get_children():
		child.queue_free()


func _reset_center_cards() -> void:
	Globals.centerCards = 0
	Globals.newcardGive.clear()
	Globals.centerHand = {
		1: {"placement": 6, "card": ""},
		2: {"placement": 7, "card": ""},
		3: {"placement": 8, "card": ""},
	}


func _on_game_manager_call_player() -> void:
	Globals.playerTurn = true
	print("Player: Start")
	
	while Globals.playerTurn:
		await get_tree().create_timer(1).timeout
	
	print("Player: Player is finished!")


func _process(delta: float) -> void:
	pass
