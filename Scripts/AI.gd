extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_game_manager_call_ai() -> void:
	print("AI: AI is here.")
	Globals.aiFinished = true
	print("AI: AI is finished.")
