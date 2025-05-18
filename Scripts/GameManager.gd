extends Node
#Health
#Who owns the turn
var ownsTurn = false
#Amount of cards on players hand
var cardAmountP1 = 0
var cardAmountP2 = 0
#Which cards are in players hand
var cardHandP1 = {}
var cardHandP2 = {}
#Are we in the state of a saveround? (The one who started has 5 cards)
var saveRound = false
#Has someone won?
var endgame = false
#Who owned the first round
var firstRound = 0
#Total sum of cards in hand
var cardSumP1 = 0
var cardSumP2 = 0
# Who wins
var winP1 = false
var winP2 = false
#Turn number
var turnNumber = 0
var roundNumber = 0
var saveRoundHappened = false

#Signals
signal callCroupier
var Croupier = "/root/Main/Croupier"
signal callPlayer
var Player = "/root/Main/Player"
signal callAI
var AI = "/root/Main/AI"

func callingCroupier():
	callCroupier.emit()
	print("GameManager: Croupier done")
func callingPlayer():
	callPlayer.emit()
	while Globals.playerTurn == true:
			await get_tree().create_timer(1).timeout
	print("GameManager: Player is done!")
func callingAI():
	callAI.emit()
	while Globals.aiTurn == true:
		await get_tree().create_timer(1).timeout
	print("GameManager: AI done")
	Globals.aiFinished = false
func playing():
	callingCroupier()
	if ownsTurn == false:
		callingPlayer()
		while Globals.playerTurn == true:
			await get_tree().create_timer(1).timeout
	elif ownsTurn == true:
		callingAI()
		while Globals.aiTurn == true:
			await get_tree().create_timer(1).timeout
	turnNumber += 1
	ownsTurn = !ownsTurn
	game_logic()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.set_max_fps(240)
	print("GameManager: Start")
	game_logic()

func game_logic():
	if Globals.healthP1 == 0:
		print("Player 1 dies...")
		endgame = true
	elif Globals.healthP2 == 0:
		print("Player 2 dies...")
		endgame = true
	else:
		if cardAmountP2 == 5 or cardAmountP1 == 5:
			if saveRound == true:
				if cardSumP1 > cardSumP2:
					Globals.healthP2 -= 1
				elif cardSumP2 > cardSumP1:
					Globals.healthP1 -= 1
				saveRound = false
			elif firstRound == true and cardAmountP2 == 5 or cardAmountP1 == 5 and firstRound == false:
				saveRound = true
		playing()
	Engine.set_max_fps(240)
	
	print("GameManager: Start")
	if Globals.healthP1 == 0:
		print("Player 1 dies...")
		endgame = true
	elif Globals.healthP2 == 0:
		print("Player 2 dies...")
		endgame = true
	else:
		if cardAmountP2 or cardAmountP1 == 5:
			if saveRound == true:
				if cardSumP1 > cardSumP2:
					Globals.healthP2 -= 1
				elif cardSumP2 > cardSumP1:
					Globals.healthP1 -= 1
				saveRound = false
				playing()
			elif firstRound == true and cardAmountP2 == 5 or cardAmountP1 == 5 and firstRound == false:
				saveRound = true
				playing()
			else:
				playing()
		else:
			playing()
