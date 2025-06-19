extends Node

# Game State
var ownsTurn = false
var saveRound = false
var saveRoundHappened = false
var firstRound = 0
var endgame = false
var winP1 = false
var winP2 = false

#region Signals
# Signals and node paths
signal callCroupier
signal callPlayer
signal callAI
var Croupier = "/root/Main/Croupier"
var Player = "/root/Main/Player"
var AI = "/root/Main/AI"
#endregion
#region Calls
func callingCroupier():
	callCroupier.emit()
	while Globals.croupierTurn:
		await get_tree().process_frame
	print("GameManager: Croupier done")

func callingPlayer():
	callPlayer.emit()
	while Globals.playerTurn:
		await get_tree().process_frame
	print("GameManager: Player is done!")

func callingAI():
	callAI.emit()
	while Globals.aiTurn:
		await get_tree().process_frame
	print("GameManager: AI done")
	Globals.aiFinished = false
#endregion

func _ready() -> void:
	Engine.set_max_fps(240)
	print("GameManager: Start")
	randomize()
	Globals.spin_revolver()
	spawns()
	game_logic()
	
func spawns():
	for i in range(1, 4):
		var node = get_tree().root.find_child("place" + str(i), true, false)   
		if node:
			Globals.positions_dict[i] = {
				"posx": node.global_position.x,
				"posy": node.global_position.y
			}
		else:
			print("Warning: Node place", i, " not found.")

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
		elif (firstRound and Globals.aiAmount == 5) or (not firstRound and Globals.playerAmount == 5):
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
	callingCroupier()

	if ownsTurn:
		await callingAI()
	else:
		await callingPlayer()

	ownsTurn = !ownsTurn
	await game_logic()
