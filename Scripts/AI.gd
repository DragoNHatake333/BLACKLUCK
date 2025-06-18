extends Node

func _on_game_manager_call_ai() -> void:
	Globals.aiTurn = true
	print("AI: Start.")
	print("AI: Done.")
	Globals.aiTurn = false


func _process(_delta: float) -> void:
	pass
