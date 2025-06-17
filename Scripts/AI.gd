extends Node

func _aiDoesNothing() -> void:
	Globals.aiTurn = false
	pass
	
	
func _ready():
	randomize()

func _on_game_manager_call_ai() -> void:
	Globals.aiTurn = true
	print("AI: Start.")
	_aiDoesNothing()
	while Globals.aiTurn == true:
		await get_tree().process_frame
	print("AI: Done.")

func _process(_delta: float) -> void:
	var total := 0
	var count := 0

	for i in Globals.aiHand:
		var card_name = Globals.aiHand[i]["card"]
		if card_name != "":
			count += 1
			if Globals.fullDeck.has(card_name):
				total += Globals.fullDeck[card_name]["value"]

	Globals.iaSum = total
	Globals.aiAmount = count
