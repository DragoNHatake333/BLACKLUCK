extends Node

var roundLoser
var ownsTurn = randi() % 2 == 0 
var round_number = 0
var starter = ownsTurn
var checking_round_winner = false
var returnRevovler = false
@onready var Blackluck = $"../Start/Blackluck"
@onready var BlackBackground = $"../Start/BlackBackground"
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
signal pressedContinue
signal callTyping
signal pressedSN(choice)
var blackluckspam = "BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK\n
BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK\n
BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK\n
BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK\n
BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK\n
BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK\n
BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK\n
BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK\n
BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK\n
BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK BLACKLUCK\n
"

var xspam = "XXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX\n
XXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX\n
XXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX\n
XXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX\n
XXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX\n
XXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX\n
XXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX\n
XXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX\n
XXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX\n
XXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX\n
"
var already = false
var start = true
@onready var bgm = $"../SoundManager/BGM"
var neededMoney = 400000
signal calculateDebt
var username = ""
signal rollcredits

func _input(event):
	if event.is_action_pressed("mouse_left"):
		pressedContinue.emit()
		if start == false:
			emit_signal("callSoundManager", "crt")

func _ready() -> void:
	Globals.debtLost = false
	if OS.has_environment("USERNAME"): # Windows
		username = OS.get_environment("USERNAME")
	elif OS.has_environment("USER"): # Linux / macOS
		username = OS.get_environment("USER")
	else:
		username = "Player"
	money = 9999999
	randomize()
	$"../Start/BlackBackground".color = Color.BLACK
	Globals.quietRevolver = false
	Globals.double = false
	Globals.gamelost = false
	Globals.startanim = true
	Globals.playerHP = 3
	Globals.aiHP = 1
	bgm.play()
	bgm.volume_db = -99
	$"../CanvasLayer/ColorRect".material.set_shader_parameter("wiggleMult", 0.0015)
	$"../CanvasLayer/ColorRect".material.set_shader_parameter("chromaticAberrationOffset", 0.001)
	$"../CanvasLayer/ColorRect".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/Sketchfab_Scene".position = Vector3(-16.99, 6.725, 2.673)
	$"../3DViewport/SubViewportContainer/SubViewport/Sketchfab_Scene".rotation_degrees = Vector3(90, -150, 0)
	$"../RevolverLight".visible = false
	$"../AiTurnLight".visible = false
	$"../PlayerTurnLight".visible = false
	BlackBackground.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	emit_signal("callSoundManager", "lightOn")
	$"../CanvasLayer/ColorRect".visible = true
	$"../SoundManager/firstBGM".playing = true
	Globals.canvasModulate = false
	await get_tree().create_timer(1.0).timeout
	#Intro
	emit_signal("callTyping")
	start = false
	Blackluck.text = "EL TEU NOM ES\n" + str(username)
	Blackluck.visible = true
	await pressedContinue
	#Second
	emit_signal("callTyping")
	Blackluck.text = "FA DOS MESOS\n VAS PERDRE UNA\n APOSTA IL·LEGAL"
	await pressedContinue
	emit_signal("callTyping")
	Blackluck.text = "ARA DEUS\n 400.000$"
	await pressedContinue
	emit_signal("callTyping")
	Blackluck.text = "AHIR VAS\n REBRE UN SMS..."
	await pressedContinue
	emit_signal("callTyping")
	Blackluck.visible = false
	$"../Start/sms".visible = true
	await pressedContinue
	$"../Start/sms".visible = false
	#Tutorial
	Blackluck.visible = false
	$"../Start/Tutorial/Frame1".visible = true
	emit_signal("callTyping")
	$"../Start/Tutorial/Blackluck".visible = true
	$"../Start/Tutorial/Blackluck2".visible = true
	$"../Start/Tutorial/Blackluck3".visible = true
	$"../Start/Tutorial/Blackluck4".visible = true
	$"../Start/Tutorial/Blackluck5".visible = true
	$"../Start/Tutorial/Cylinder".visible = true
	await pressedContinue
	$"../Start/Tutorial/Cylinder".visible = false
	$"../Start/Tutorial/Frame1".visible = false
	$"../Start/Tutorial/Blackluck".visible = false
	$"../Start/Tutorial/Blackluck2".visible = false
	$"../Start/Tutorial/Blackluck3".visible = false
	$"../Start/Tutorial/Blackluck4".visible = false
	$"../Start/Tutorial/Blackluck5".visible = false
	Blackluck.visible = true
	emit_signal("callTyping")
	Blackluck.text = blackluckspam
	await pressedContinue
	start = true
	await get_tree().process_frame
	emit_signal("callSoundManager", "lightOff")
	$"../SoundManager/firstBGM".autoplay = false
	$"../SoundManager/firstBGM".playing = false
	$"../Start/ShakiShaki".visible = false
	Blackluck.visible = false
	await get_tree().create_timer(3.0).timeout
	emit_signal("callSoundManager", "lightOn")
	BlackBackground.visible = false
	Globals.canvasModulate = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$"../RevolverLight".visible = true
	check_candle_lighting("restart", "ai")
	check_candle_lighting("restart", "player")
	var tween2 = create_tween()
	tween2.tween_property(bgm, "volume_db", -15.215, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
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
	Globals.startanim = false
	game_logic()
	
func game_logic():
	print("GameManager: Logic start.")
	if Globals.playerHP == 0:
		Globals.quietRevolver = true
		Globals.gamelost = true
		game_lost()
		await get_tree().process_frame
		return
	if Globals.aiHP == 0:
		Globals.quietRevolver = true
		Globals.gamelost = true
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
		await check_round_winner()

					
	ownsTurn = !ownsTurn
	round_number += 1
	game_logic()

func game_lost():
	Globals.startanim = true
	var tween = get_tree().create_tween()
	tween.tween_property(bgm, "volume_db", -100, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	BlackBackground.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	emit_signal("callSoundManager", "lightOn")
	$"../SoundManager/firstBGM".playing = true
	$"../Start/ShakiShaki".visible = true
	Globals.canvasModulate = false
	Blackluck.visible = true
	emit_signal("callTyping")
	Blackluck.text = "DERROTA"
	await pressedContinue
	emit_signal("callTyping")
	Blackluck.visible = true
	Blackluck.text = "..."
	emit_signal("callSoundManager", "noescape")
	await pressedContinue
	Blackluck.visible = false
	start = false
	Globals.debtLost = true
	emit_signal("calculateDebt")
	emit_signal("callTyping")
	$"../End/OSNAME".visible = true
	$"../End/Date".visible = true
	$"../End/Debt".visible = true
	$"../End/Panel".visible = true
	await pressedContinue
	$"../End/OSNAME".visible = false
	$"../End/Date".visible = false
	$"../End/Debt".visible = false
	$"../End/Panel".visible = false
	SceneManager.change_scene("res://Scenes/MainMenu/Scenes/MainMenu.tscn")
	
func game_won():
	Globals.quietRevolver = true
	var oldmoney
	Globals.startanim = true
	var tween = get_tree().create_tween()
	tween.tween_property(bgm, "volume_db", -100, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if Globals.double == true:
		money *= 2
	else:
		money = randi_range(100000, 150000) + money
	print("GAME FINISHED: PLAYER WINS")
	BlackBackground.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	emit_signal("callSoundManager", "lightOn")
	$"../SoundManager/firstBGM".playing = true
	$"../Start/ShakiShaki".visible = true
	Globals.canvasModulate = false
	start = false
	Blackluck.visible = true
	emit_signal("callTyping")
	Blackluck.text = "VICTÒRIA"
	await pressedContinue
	emit_signal("callTyping")
	Blackluck.text = "DEUTE:\n" + str(neededMoney - money) + "$"
	await pressedContinue
	Blackluck.visible = false
	$"../Start/HBoxContainer".visible = true
	$"../Start/HBoxContainer/Yes".visible = true
	$"../Start/HBoxContainer/No".visible = true
	if (neededMoney - money) <= 0:
		$"../Start/HBoxContainer/No".add_theme_color_override("font_color", "ff0000")
		$"../Start/HBoxContainer/No".disabled = false
	else:
		$"../Start/HBoxContainer/No".add_theme_color_override("font_color", "410000")
		$"../Start/HBoxContainer/No".disabled = true
	# Wait until either S or N is pressed
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var res = await pressedSN   # returns emitted args as an Array
	var choice = res[0]
	if choice == "n":
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		$"../Start/HBoxContainer".visible = false
		$"../Start/HBoxContainer/Yes".visible = false
		$"../Start/HBoxContainer/No".visible = false
		$"../SoundManager/firstBGM".playing = false
		start = false
		Blackluck.visible = true
		emit_signal("callTyping")
		$"../SoundManager/door".play()
		Blackluck.text = "NO TORNIS"
		await pressedContinue
		$"../SoundManager/door".stop()
		#emit_signal("calculateDebt")
		#emit_signal("callTyping")
		#$"../End/OSNAME".visible = true
		#$"../End/Date".visible = true
		#$"../End/Debt".visible = true
		#$"../End/Panel".visible = true
		#await pressedContinue
		#$"../End/OSNAME".visible = false
		#$"../End/Date".visible = false
		#$"../End/Debt".visible = false
		#$"../End/Panel".visible = false
		Blackluck.visible = false
		var tween2 = get_tree().create_tween()
		tween2.tween_property($"../Start/BlackBackground", "color", Color.WHITE, 6.0).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
		$"../SoundManager/escape".play()
		Blackluck.add_theme_color_override("font_color", "f6b400")
		await get_tree().create_timer(20.0).timeout
		$"../End/credits".visible = true
		var tween3 = get_tree().create_tween()
		tween3.tween_property(bgm, "volume_db", 2.811, 5.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		$"../SoundManager/credits".play()
		emit_signal("rollcredits")
		await pressedContinue
		SceneManager.change_scene("res://Scenes/MainMenu/Scenes/MainMenu.tscn")
	elif choice == "s":
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		checking_round_winner = true
		Globals.aiHP = 3
		check_candle_lighting("restart", "ai")
		reset_round()  # Delayed check
		while checking_round_winner == true:
			await get_tree().process_frame	
		$"../SoundManager/firstBGM".playing = false
		Globals.canvasModulate = true
		Blackluck.visible = false
		start = true
		$"../Start/ShakiShaki".visible = false
		$"../Start/HBoxContainer".visible = false
		$"../Start/HBoxContainer/Yes".visible = false
		$"../Start/HBoxContainer/No".visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		var tween2 = create_tween()
		tween2.tween_property($"../SoundManager/credits", "volume_db", -15.215, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		Globals.startanim = false
		Globals.double = true
		Globals.quietRevolver = false
		emit_signal("callAnimationManager", "candle", "ai", null)
		BlackBackground.visible = false
		await $"../AnimationManager".AnimationFinished
		game_logic()

func check_round_winner():
	if checking_round_winner:
		return
	
	checking_round_winner = true
	if Globals.playerSum > Globals.aiSum:
		Globals.aiHP -= 1
		roundLoser = "ai"
		if $"../Terminator".revolverPressed == false:
			await get_tree().create_timer(1.0).timeout
			emit_signal("callAnimationManager", "candle", "ai", null)
			await $"../AnimationManager".AnimationFinished
		await get_tree().create_timer(1.0).timeout
		reset_round()
	elif Globals.aiSum > Globals.playerSum:
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
		var tween = get_tree().create_tween()
		tween.tween_property(bgm, "volume_db", -100, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		$"../SoundManager/firstBGM".autoplay = true
		$"../SoundManager/firstBGM".playing = true
		Globals.startanim = true
		BlackBackground.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		Globals.canvasModulate = false
		emit_signal("callSoundManager", "lightOff")
		Blackluck.visible = true
		emit_signal("callTyping")
		Blackluck.text = "EMPAT"
		await pressedContinue
		checking_round_winner = false
		reset_round()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Globals.canvasModulate = true
		emit_signal("callSoundManager", "lightOn")
		Blackluck.visible = false
		BlackBackground.visible = false
		Globals.startanim = false
		$"../SoundManager/firstBGM".autoplay = false
		$"../SoundManager/firstBGM".playing = false
		var tween2 = get_tree().create_tween()
		tween2.tween_property(bgm, "volume_db", -15.215, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		return

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
	already = false

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


func _on_yes_button_up() -> void:
	pressedSN.emit("s")
	if start == false:
		emit_signal("callSoundManager", "crt")


func _on_no_button_up() -> void:
	pressedSN.emit("n")
	if start == false:
		emit_signal("callSoundManager", "crt")
