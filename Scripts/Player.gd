extends Node
var player_calling_player = false
var player_ended_player = false

func _on_button_pressed() -> void:
	Globals.revolver_pressed = true
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_calling_player == true:
		_on_button_pressed()
	else:
		pass
func _on_game_manager_call_player() -> void:
	print("Player: Player is here!")
	var player_calling_player = true
	while player_ended_player == false:
		await get_tree().create_timer(4.0).timeout
		print("Waiting 4 second...")
	
	
	
	
	
	
	
	
	Globals.playerFinished = true
	print("Player: Player is finished!")
