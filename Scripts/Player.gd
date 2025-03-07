extends Node
var stopstack = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_game_manager_call_player() -> void:
	print("Player: Player is here!")
	Globals.playerFinished = true
	print("Player: Player is finished!")
