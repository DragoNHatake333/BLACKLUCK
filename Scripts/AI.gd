extends Node

func _on_game_manager_call_ai() -> void:
	print("AI: AI is here.")
	Globals.aiFinished = true
	print("AI: AI is finished.")
