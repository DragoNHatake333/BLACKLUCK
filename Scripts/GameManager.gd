extends Node

# Game State
var ownsTurn = false
var saveRound = false
var saveRoundHappened = false
var round_number = 0
var endgame = false
var winP1 = false
var winP2 = false

#region Signals
# Signals and node paths
signal callDeck
signal callPlayer
signal callAI
var Croupier = "/root/Main/Croupier"
var Player = "/root/Main/Player"
var AI = "/root/Main/AI"
#endregion
#region Calls
func callingDeck():
	callDeck.emit()
	while Globals.turn == 0:
		await get_tree().process_frame
	print("GameManager: Croupier done")

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
	game_logic()

# Main game loop
func game_logic():
	if Globals.playerHP <= 0:
		print("Player dies...")
		endgame = true
		return
	elif Globals.aiHP <= 0:
		print("AI dies...")
		endgame = true
		return

	# Round-end logic
	if Globals.playerAmount == 5 or Globals.aiAmount == 5:
		if saveRound == true:
			process_round_winner()
			saveRound = false
		elif (round_number == 1 and Globals.aiAmount == 5) or (round_number != 1  and Globals.playerAmount == 5):
			saveRound = true

	await playing()

# Turn-based logic
func process_round_winner():
	if Globals.playerSum > Globals.aiSum:
		Globals.aiHP -= 1
	elif Globals.aiSum > Globals.playerSum:
		Globals.playerHP -= 1

# Manage a full turn
func playing():
	callingDeck()

	if ownsTurn:
		await callingAI()
	else:
		await callingPlayer()

	ownsTurn = !ownsTurn
	round_number + 1
	print(round_number)
	await game_logic()
