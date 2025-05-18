extends Node

var Croupier = "/root/Main/Croupier"
var GameManager = "/root/Main/GameManager"
func _on_button_pressed() -> void:
	if Globals.playerTurn == true:
		print("Player: Revolver")
		for child in get_node(Croupier).get_children():
			child.queue_free()
		Globals.centerCards = 0
		Globals.newcardGive = []
		Globals.centerHand = {
		1: {"placement": 6, "card": ""},
		2: {"placement": 7, "card": ""}, 
		3: {"placement": 8, "card": ""},
		}
		get_node(GameManager).callingCroupier()
		Globals.playerTurn = false
	else:
		pass
		
func _process(delta: float) -> void:
	if Globals.playerTurn == true:
		
		pass
func _on_game_manager_call_player() -> void:
	Globals.playerTurn = true
	print("Player: Start")
	while Globals.playerTurn == true:
		await get_tree().create_timer(1).timeout
	print("Player: Player is finished!")
