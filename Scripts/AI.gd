extends Node

func _on_game_manager_call_ai() -> void:
	Globals.aiTurn = true
	print("AI: Start.")
	while Globals.aiTurn == true:
		await get_tree().create_timer(1).timeout
	print("AI: Done.")
