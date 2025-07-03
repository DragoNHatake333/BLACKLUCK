extends Node

var ownsTurn = randi() % 2 == 0 
var round_number = 0
var win #Player is true AI is false
var starter = ownsTurn
var checking_round_winner = false
var returnRevovler = false
@onready var Blackluck = $"../Blackluck"
@onready var revolverSpin = $"../Sounds/revolverSpin"
signal resetCardSlots
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
		game_won()
		await get_tree().process_frame
		return
	if Globals.aiHP == 0:
		win = "player"
		game_won()
		await get_tree().process_frame
		return
	
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
		if Globals.playerShootHimself == false:
			emit_signal("callCountAmount")
		Globals.playerShootHimself = false
		print("GameManager: Player done.")
	else:
		print("GameManager: AI called.")
		Globals.aiTurn = true
		callAI.emit()
		while Globals.aiTurn == true:
			await get_tree().process_frame
		if Globals.aiShootHimself == false:
			emit_signal("callCountAmount")
		Globals.aiShootHimself = false
		print("GameManager: AI done.")
	
	# Check player's cards
	if Globals.playerAmount == 5 and Globals.aiAmount == 5:
		checking_round_winner = true
		check_round_winner()  # Delayed check
		while checking_round_winner == true:
			await get_tree().process_frame

					
	ownsTurn = !ownsTurn
	round_number += 1
	game_logic()
	
func game_won():
	print("GAME FINISHED: ", win, " wins.")
	Blackluck.text = str(win) + " wins."
	Blackluck.visible = true

	
func check_round_winner():
	if Globals.playerSum > Globals.aiSum:
		Globals.aiHP -= 1
		reset_round()
	if Globals.aiSum > Globals.playerSum:
		Globals.playerHP -= 1
		reset_round()
	else:
		reset_round()

func reset_round():
	for i in $"../CardManager".get_children():
		i.queue_free()
	emit_signal("resetCardSlots")
	Globals.playerSum = 0
	Globals.playerHand = []
	Globals.playerAmount = 0
	Globals.aiSum = 0
	Globals.aiHand = []
	Globals.aiAmount = 0
	Globals.cards_in_center_hand = 0
	Globals.centerHand = []
	Globals.saveRound = false
	Globals.spin_revolver()
	Globals.centerDeck = Globals.fullCenterDeck
	Globals.centerDeck.shuffle()
	print("GameManager: Reset round finished!")
	checking_round_winner = false
