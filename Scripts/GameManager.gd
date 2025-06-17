extends Node

# Game State
var ownsTurn = false
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

var player_death_sprite: Sprite2D
var deathsound: AudioStreamPlayer

func show_player_death_effect():
	player_death_sprite.visible = true
	player_death_sprite.modulate.a = 0.0

	var tween = create_tween()
	tween.tween_property(player_death_sprite, "modulate:a", 1.0, 3.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_interval(2.0)
	deathsound.play()
	tween.tween_property(player_death_sprite, "modulate:a", 0.0, 3.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

# Startup
func _ready() -> void:
	Engine.set_max_fps(240)
	print("GameManager: Start")
	Globals.spin_revolver()
	player_death_sprite = get_node("/root/Main/PlayerDeath")
	deathsound = get_node("/root/Main/Sounds/deathsound")
	player_death_sprite.visible = false
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
	
func reset_round():
	print("GameManager: Resetting round...")

	# Reset cardDict from fullDeck
	Globals.cardDict = Globals.fullDeck.duplicate(true)

	# Clear player, AI, and center hands
	for i in Globals.playerHand:
		Globals.playerHand[i]["card"] = ""
	for i in Globals.aiHand:
		Globals.aiHand[i]["card"] = ""
	for i in Globals.centerHand:
		Globals.centerHand[i]["card"] = ""

	Globals.centerCards = 0
	Globals.newcardGive.clear()

	# Clear visual cards (first)
	var croupier = get_node_or_null("/root/Main/Croupier")
	if croupier:
		for child in croupier.get_children():
			child.queue_free()

	var player = get_node_or_null("/root/Main/Player")
	if player:
		for child in player.get_children():
			if child is Area2D:
				child.queue_free()

	var ai = get_node_or_null("/root/Main/AI")
	if ai:
		for child in ai.get_children():
			if child is Area2D:
				child.queue_free()

	# Delay a frame so nodes are actually freed
	await get_tree().process_frame

	# Reset all drop zones *after* nodes are gone
	for i in range(1, 16):
		var drop_zone = get_tree().root.find_child("place" + str(i), true, false)
		if drop_zone and drop_zone.is_in_group("drop_zone"):
			drop_zone.occupied = false
			drop_zone.occupying_card = null


	# Re-spin revolver
	Globals.spin_revolver()

	# Begin new round
	game_logic()

# Main game loop
func game_logic():
	if endgame:
		return

	if Globals.healthP1 <= 0:
		print("Player dies...")
		endgame = true
		show_player_death_effect()
		return
	elif Globals.healthP2 <= 0:
		print("AI dies...")
		endgame = true
		return

	# Round-end logic
	if Globals.playerAmount == 5 or Globals.aiAmount == 5:
		if saveRound:
			process_round_winner()
			saveRound = false
		elif (firstRound and Globals.aiAmount == 5) or (not firstRound and Globals.playerAmount == 5):
			saveRound = true

	await playing()

# Turn-based logic
func process_round_winner():
	if cardSumP1 > cardSumP2:
		Globals.healthP2 -= 1
	elif cardSumP2 > cardSumP1:
		Globals.healthP1 -= 1
	#get_node("/root/Main/GameManager").reset_round()

func callingCroupier():
	callCroupier.emit()
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
