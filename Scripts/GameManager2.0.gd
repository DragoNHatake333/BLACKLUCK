extends Node

var roundLoser
var ownsTurn = randi() % 2 == 0 
var round_number = 0
var starter = ownsTurn
var checking_round_winner = false
var returnRevovler = false
@onready var Blackluck = $"../Blackluck"
var money = 0
signal resetCardSlots
signal callCountAmount
signal callDeck
signal callPlayer
signal callAI
var Deck = "/root/Main/Deck"
var Player = "/root/Main/Player"
var AI = "/root/Main/AI"
signal callSoundManager
signal callAnimationManager

func _ready() -> void:
	randomize()
	$"../AiTurnLight".visible = false
	$"../PlayerTurnLight".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/Sketchfab_Scene".position = Vector3(-16.99, 6.725, 2.673)
	$"../3DViewport/SubViewportContainer/SubViewport/Sketchfab_Scene".rotation_degrees = Vector3(90, -150, 0)
	check_candle_lighting("restart", "ai")
	check_candle_lighting("restart", "player")
	money = 0
	Globals.canvasModulate = true
	Globals.playerSum = 0
	Globals.playerHand = []
	Globals.playerAmount = 0
	Globals.aiSum = 0
	Globals.aiHand = []
	Globals.aiAmount = 0
	Globals.cards_in_center_hand = 0
	Globals.centerHand = []
	Globals.saveRound = false
	#Engine.set_max_fps(240)
	print("GameManager: Start") 
	Globals.spin_revolver()
	#await 
	game_logic()
	
func game_logic():
	print("GameManager: Logic start.")
	if Globals.playerHP == 0:
		game_lost()
		await get_tree().process_frame
		return
	if Globals.aiHP == 0:
		game_won()
		await get_tree().process_frame
		return
	
	print("GameManager: Deck called.")
	Globals.deckTurn = true
	callDeck.emit()
	while Globals.deckTurn == true:
		await get_tree().process_frame
	print("GameManager: Deck done.")
	await get_tree().create_timer(0.5).timeout
	
	if ownsTurn:
		print("GameManager: Player called.")
		Globals.playerTurn = true
		callPlayer.emit()
		while Globals.playerTurn == true:
			if not get_tree():
				return
			else:
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
			if not get_tree():
				return
			else:
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

func game_lost():
	print("GAME FINISHED: PLAYER LOSES")
	Blackluck.text = "DEAD\n" + str(money) + "$"
	Blackluck.visible = true
	await get_tree().create_timer(5.0).timeout
	SceneManager.change_scene("res://ui/MainMenu/Scenes/MainMenu.tscn")
	
func game_won():
	money += 500000
	print("GAME FINISHED: PLAYER WINS")
	Blackluck.text = str(money) + "$"
	Blackluck.visible = true
	checking_round_winner = true
	Globals.aiHP = 3
	check_candle_lighting("restart", "ai")
	reset_round()  # Delayed check
	while checking_round_winner == true:
		await get_tree().process_frame	
	await get_tree().create_timer(5.0).timeout
	Blackluck.visible = false
	game_logic()

func check_round_winner():
	if Globals.playerSum > Globals.aiSum:
		Globals.aiHP -= 1
		roundLoser = "ai"
		if $"../Terminator".revolverPressed == false:
			await get_tree().create_timer(1.0).timeout
			emit_signal("callAnimationManager", "candle", "ai", null)
			await $"../AnimationManager".AnimationFinished
		await get_tree().create_timer(1.0).timeout
		reset_round()
	if Globals.aiSum > Globals.playerSum:
		Globals.playerHP -= 1
		roundLoser = "player"
		if Globals.playerRevolverPressed == false:
			await get_tree().create_timer(1.0).timeout
			emit_signal("callAnimationManager", "candle", "player", null)
			await $"../AnimationManager".AnimationFinished
		await get_tree().create_timer(1.0).timeout
		reset_round()
	else:
		roundLoser = ""
		reset_round()

func reset_round():
	if roundLoser == "player":
		ownsTurn = true
	elif roundLoser == "ai":
		ownsTurn = false
	else:
		ownsTurn = randi() % 2 == 0  # fallback for ties or first round
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

func check_candle_lighting(operation, who):
	if operation == "check":
		if who == "player":
			print("CHECKING PLAYER!")
			if Globals.playerHP == 3:
				$"../CandleLights/PointP1".visible = true
				$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/FireP1".visible = true
				$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/SpotP1".visible = true
				$"../CandleLights/PointP2".visible = true
				$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP2/FireP2".visible = true
				$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP2/SpotP2".visible = true
				$"../CandleLights/PointP3".visible = true
				$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP3/FireP3".visible = true
				$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP3/SpotP3".visible = true
			if Globals.playerHP == 2:
				if $"../CandleLights/PointP1".visible == true:
					emit_signal("callSoundManager", "candleOff")
				$"../CandleLights/PointP1".visible = false
				$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/FireP1".visible = false
				$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/SpotP1".visible = false
				$"../CandleLights/PointP2".visible = true
				$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP2/FireP2".visible = true
				$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP2/SpotP2".visible = true
				$"../CandleLights/PointP3".visible = true
				$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP3/FireP3".visible = true
				$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP3/SpotP3".visible = true
			if Globals.playerHP == 1:
				if $"../CandleLights/PointP2".visible == true:
					emit_signal("callSoundManager", "candleOff")
				$"../CandleLights/PointP1".visible = false
				$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/FireP1".visible = false
				$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/SpotP1".visible = false
				$"../CandleLights/PointP2".visible = false
				$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP2/FireP2".visible = false
				$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP2/SpotP2".visible = false
				$"../CandleLights/PointP3".visible = true
				$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP3/FireP3".visible = true
				$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP3/SpotP3".visible = true
			if Globals.playerHP == 0:
				if $"../CandleLights/PointP3".visible == true:
					emit_signal("callSoundManager", "candleOff")
				$"../CandleLights/PointP1".visible = false
				$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/FireP1".visible = false
				$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/SpotP1".visible = false
				$"../CandleLights/PointP2".visible = false
				$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP2/FireP2".visible = false
				$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP2/SpotP2".visible = false
				$"../CandleLights/PointP3".visible = false
				$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP3/FireP3".visible = false
				$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP3/SpotP3".visible = false

		if who == "ai":
			print("CHECKING AI!")
			if Globals.aiHP == 3:
				$"../CandleLightsAI/PointA1".visible = true
				$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA1/FireA1".visible = true
				$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA1/SpotA1".visible = true
				$"../CandleLightsAI/PointA2".visible = true
				$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA2/FireA2".visible = true
				$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA2/SpotA2".visible = true
				$"../CandleLightsAI/PointA3".visible = true
				$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA3/FireA3".visible = true
				$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA3/SpotA3".visible = true
			if Globals.aiHP == 2:
				if $"../CandleLightsAI/PointA1".visible == true:
					emit_signal("callSoundManager", "candleOffAI")
				$"../CandleLightsAI/PointA1".visible = false
				$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA1/FireA1".visible = false
				$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA1/SpotA1".visible = false
				$"../CandleLightsAI/PointA2".visible = true
				$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA2/FireA2".visible = true
				$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA2/SpotA2".visible = true
				$"../CandleLightsAI/PointA3".visible = true
				$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA3/FireA3".visible = true
				$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA3/SpotA3".visible = true
			if Globals.aiHP == 1:
				if $"../CandleLightsAI/PointA2".visible == true:
					emit_signal("callSoundManager", "candleOffAI")
				$"../CandleLightsAI/PointA1".visible = false
				$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA1/FireA1".visible = false
				$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA1/SpotA1".visible = false
				$"../CandleLightsAI/PointA2".visible = false
				$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA2/FireA2".visible = false
				$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA2/SpotA2".visible = false
				$"../CandleLightsAI/PointA3".visible = true
				$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA3/FireA3".visible = true
				$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA3/SpotA3".visible = true
			if Globals.aiHP == 0:
				if $"../CandleLightsAI/PointA3".visible == true:
					emit_signal("callSoundManager", "candleOffAI")
				$"../CandleLightsAI/PointA1".visible = false
				$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA1/FireA1".visible = false
				$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA1/SpotA1".visible = false
				$"../CandleLightsAI/PointA2".visible = false
				$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA2/FireA2".visible = false
				$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA2/SpotA2".visible = false
				$"../CandleLightsAI/PointA3".visible = false
				$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA3/FireA3".visible = false
				$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA3/SpotA3".visible = false

		if who == "both":
			print("CHECKING BOTH!")
			check_candle_lighting("check", "player")
			check_candle_lighting("check", "ai")
			return

	elif operation == "restart":
		if who == "ai":
			$"../CandleLightsAI/PointA1".visible = true
			$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA1/FireA1".visible = true
			$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA1/SpotA1".visible = true
			$"../CandleLightsAI/PointA2".visible = true
			$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA2/FireA2".visible = true
			$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA2/SpotA2".visible = true
			$"../CandleLightsAI/PointA3".visible = true
			$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA3/FireA3".visible = true
			$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA3/SpotA3".visible = true
		if who == "player":
			$"../CandleLights/PointP1".visible = true
			$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/FireP1".visible = true
			$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/SpotP1".visible = true
			$"../CandleLights/PointP2".visible = true
			$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP2/FireP2".visible = true
			$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP2/SpotP2".visible = true
			$"../CandleLights/PointP3".visible = true
			$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP3/FireP3".visible = true
			$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP3/SpotP3".visible = true
	else:
		print("check_candle_lighting: invalid operation argument")


func _process(_delta: float) -> void:
	if Globals.aiTurn == true:
		$"../AiTurnLight".visible = true
		$"../PlayerTurnLight".visible = false
	if Globals.playerTurn == true:
		$"../PlayerTurnLight".visible = true
		$"../AiTurnLight".visible = false
	if Globals.canvasModulate == true:
		$"../CanvasModulate".color = "222222"
	elif Globals.canvasModulate == false:
		$"../CanvasModulate".color = "ffffff"
	if Globals.playerHP == 3:
		$"../PointLight2D".color = "ff3f30"
	if Globals.playerHP == 2:
		$"../PointLight2D".color = "ff3629"
	if Globals.playerHP == 1:
		$"../PointLight2D".color = "b70000"
