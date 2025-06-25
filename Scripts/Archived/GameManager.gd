extends Node

var ownsTurn = randi() % 2 == 0 
var saveRound = false
var saveRoundHappened = false
var round_number = 0
var endgame = false
var winP1 = false
var winP2 = false
var starter = ownsTurn


signal callDeck
signal callPlayer
signal callAI
var Croupier = "/root/Main/Croupier"
var Player = "/root/Main/Player"
var AI = "/root/Main/AI"

#region Calls
func callingDeck():
	callDeck.emit()
	while Globals.turn == 0:
		await get_tree().process_frame
	print("GameManager: Deck done")

func callingPlayer():
	callPlayer.emit()
	while Globals.turn == 1:
		await get_tree().process_frame
	print("GameManager: Player is done!")

func callingAI():
	callAI.emit()
	while Globals.turn == 2:
		await get_tree().process_frame
	print("GameManager: AI done")
#endregion

func _ready() -> void:
	Engine.set_max_fps(240)
	print("GameManager: Start")
	randomize()
	Globals.spin_revolver()
	await game_logic()

# Main game loop
func game_logic():
	while not endgame:
		if Globals.playerHP <= 0:
			print("Player dies...")
			endgame = true
			break
		elif Globals.aiHP <= 0:
			print("AI dies...")
			endgame = true
			break
		
		if Globals.playerAmount >= 5 or Globals.aiAmount >= 5:
			if starter == true and Globals.aiAmount >= 5 and saveRound == false:
				saveRound = true
			if starter == false and Globals.playerAmount >= 5 and saveRound == false:
				saveRound = true
			else:
				process_round_winner()

		await playing()
		round_number += 1

# Turn-based logic
func process_round_winner():
	if Globals.playerSum > Globals.aiSum:
		Globals.aiHP -= 1
		await reset_round()
	elif Globals.aiSum > Globals.playerSum:
		Globals.playerHP -= 1
		await reset_round()

# Manage a full turn
func playing():
	Globals.turn = 0
	await callingDeck()

	if ownsTurn:
		Globals.turn = 2
		await callingAI()
	else:
		Globals.turn = 1
		await callingPlayer()

	ownsTurn = !ownsTurn
	round_number + 1
	#print(round_number)

func reset_round():
	print("Round Reset")
	#Resetting values
	Globals.playerAmount = 0
	Globals.playerHand.clear()
	Globals.playerSum = 0
	Globals.aiAmount = 0
	Globals.aiHand.clear()
	Globals.aiSum = 0
	Globals.centerHand.clear()
	Globals.cards_in_center_hand = 0
	saveRound = false
	
	#Freeing CardSlots so that new cards can be placed.
	var iaHand = get_node_or_null("../iaHand")
	if iaHand:
		for child in iaHand.get_children():
			if child is CardSlot:
				child.card_added = false

	var playerHand = get_node_or_null("../playerHand")
	if playerHand:
		for child in playerHand.get_children():
			if child is CardSlot:
				child.card_added = false

	#Deleting all cards instantiated
	var card_manager = get_node_or_null("../CardManager")
	if card_manager:
		for child in card_manager.get_children():
			child.queue_free()

	ownsTurn = randi() % 2 == 0 
	Globals.spin_revolver()
	print("finished")
