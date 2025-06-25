extends Node

var ownsTurn = randi() % 2 == 0 
var saveRound = false
var saveRoundHappened = false
var round_number = 0
var win #Player is true AI is false
var starter = ownsTurn

signal callCountAmount
signal callDeck
signal callPlayer
signal callAI
var Deck = "/root/Main/Deck"
var Player = "/root/Main/Player"
var AI = "/root/Main/AI"

func _ready() -> void:
	Engine.set_max_fps(240)
	print("GameManager: Start")
	randomize()
	Globals.spin_revolver()
	game_logic()
	
func game_logic():
	print("GameManager: Logic start.")
	if Globals.playerHP == 0:
		win = "ai"
		game_won(win)
	if Globals.aiHP == 0:
		win = "player"
		game_won(win)
	
	print("GameManager: Deck called.")
	Globals.deckTurn = true
	callDeck.emit()
	while Globals.deckTurn == true:
		await get_tree().process_frame
	print("GameManager: Deck done.")
	
	if ownsTurn:
		print("GameManager: Player called.")
		Globals.playerTurn = true
		callPlayer.emit()
		while Globals.playerTurn == true:
			await get_tree().process_frame
		emit_signal("callCountAmount")
		print("GameManager: Player done.")
	else:
		print("GameManager: AI called.")
		Globals.aiTurn = true
		callAI.emit()
		while Globals.aiTurn == true:
			await get_tree().process_frame
		emit_signal("callCountAmount")
		print("GameManager: AI done.")
	
	# Check player's cards
	if Globals.playerAmount == 5:
		print("Player has 5 cards.")
		if starter:  # Player's turn
			if not saveRound:
				saveRound = true  # Delay check
			else:
				check_round_winner()  # Delayed check
		else:  # AI's turn
			check_round_winner()  # Immediate check

	# Check AI's cards
	if Globals.aiAmount == 5:
		print("ai has 5")
		if not starter:  # AI's turn
			if not saveRound:
				saveRound = true  # Delay check
			else:
				check_round_winner()  # Delayed check
		else:  # Player's turn
			check_round_winner()  # Immediate check

	
	ownsTurn = !ownsTurn
	round_number += 1
	game_logic()
	
func game_won(win):
	pass
	
func check_round_winner():
	print("GameManager: Checking round winner!")
	
