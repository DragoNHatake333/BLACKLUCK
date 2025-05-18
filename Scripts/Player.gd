extends Node

var Croupier = "/root/Main/Croupier"
var GameManager = "/root/Main/GameManager"
func _on_button_pressed() -> void:
	print("Player: Revolver")
	#Globals.pressed_revolver = true
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
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_game_manager_call_player() -> void:
	print("Player: Start")
	while Globals.playerFinished == false:
		await get_tree().create_timer(1).timeout
	print("Player: Player is finished!")
