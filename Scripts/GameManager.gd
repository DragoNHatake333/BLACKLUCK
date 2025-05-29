extends Node

# Game State
var ownsTurn = false
var cardAmountP1 = 0
var cardAmountP2 = 0
var cardHandP1 = {}
var cardHandP2 = {}
var cardSumP1 = 0
var cardSumP2 = 0
var turnNumber = 0
var roundNumber = 0
var saveRound = false
var saveRoundHappened = false
var firstRound = 0
var endgame = false
var winP1 = false
var winP2 = false

# Signals and node paths
signal callCroupier
signal callPlayer
signal callAI
var Croupier = "/root/Main/Croupier"
var Player = "/root/Main/Player"
var AI = "/root/Main/AI"



# Startup
func _ready() -> void:
	Engine.set_max_fps(240)
	print("GameManager: Start")
	for i in range(1, 16):
		var node = get_tree().root.find_child("place" + str(i), true, false)   
		if node:
			Globals.positions_dict[i] = {
				"posx": node.global_position.x,
				"posy": node.global_position.y
			}
		else:
			print("Warning: Node place", i, " not found.")
	game_logic()

# Main game loop
func game_logic():
	if endgame:
		return

	if Globals.healthP1 <= 0:
		print("Player 1 dies...")
		endgame = true
		return
	elif Globals.healthP2 <= 0:
		print("Player 2 dies...")
		endgame = true
		return

	# Round-end logic
	if cardAmountP1 == 5 or cardAmountP2 == 5:
		if saveRound:
			process_round_winner()
			saveRound = false
		elif (firstRound and cardAmountP2 == 5) or (not firstRound and cardAmountP1 == 5):
			saveRound = true

	await playing()

# Turn-based logic
func process_round_winner():
	if cardSumP1 > cardSumP2:
		Globals.healthP2 -= 1
	elif cardSumP2 > cardSumP1:
		Globals.healthP1 -= 1

func callingCroupier():
	callCroupier.emit()
	print("GameManager: Croupier done")

func callingPlayer():
	callPlayer.emit()
	while Globals.playerTurn:
		await get_tree().create_timer(1).timeout
	print("GameManager: Player is done!")

func callingAI():
	callAI.emit()
	while Globals.aiTurn:
		await get_tree().create_timer(1).timeout
	print("GameManager: AI done")
	Globals.aiFinished = false

# Manage a full turn
func playing():
	callingCroupier()

	if ownsTurn:
		await callingAI()
	else:
		await callingPlayer()

	turnNumber += 1
	ownsTurn = !ownsTurn
	await game_logic()
