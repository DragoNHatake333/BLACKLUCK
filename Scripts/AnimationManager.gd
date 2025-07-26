extends Node
signal AnimationFinished
signal callSoundManager
var revolverPos = "player"
@onready var revolver = $"../3DViewport/SubViewportContainer/SubViewport/Sketchfab_Scene"
var thereWasAnimation = false

func callAnimationManager(anime, who, what) -> void:
	if anime == "candle":
		var tween = create_tween()
		
		# Fade out BGM
		var bgm = $"../SoundManager/BGM"
		tween.tween_property(bgm, "volume_db", -40, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
		emit_signal("callSoundManager", "lightOff")
		await get_tree().create_timer(0.2).timeout
		
		for i in $"../CardManager".get_children():
			i.visible = false
		for i in $"../iaHand".get_children():
			i.visible = false
		for i in $"../playerHand".get_children():
			i.visible = false
		
		var savedColour = $"../CanvasModulate".color
		$"../CanvasModulate".color = Color.BLACK

		if who == "player":
			$"../PlayerTurnLight".visible = true
			$"../AiTurnLight".visible = false
		if who == "ai":
			$"../PlayerTurnLight".visible = false
			$"../AiTurnLight".visible = true

		$"../PointLight2D".visible = false
		$"../3DViewport/SubViewportContainer/SubViewport/SpotLight3D".visible = false
		$"../3DViewport/SubViewportContainer/SubViewport/RevolverLight".visible = false

		await get_tree().create_timer(1.0).timeout
		$"../GameManager".check_candle_lighting("check", "ai")
		$"../GameManager".check_candle_lighting("check", "player")
		await get_tree().create_timer(3.0).timeout

		emit_signal("callSoundManager", "lightOn")
		await get_tree().create_timer(0.1).timeout

		for i in $"../iaHand".get_children():
			i.visible = true
		for i in $"../playerHand".get_children():
			i.visible = true

		$"../CanvasModulate".color = savedColour
		$"../3DViewport/SubViewportContainer/SubViewport/SpotLight3D".visible = true
		$"../3DViewport/SubViewportContainer/SubViewport/RevolverLight".visible = true
		$"../PointLight2D".visible = true

		# Fade BGM back in
		var tween2 = create_tween()
		tween2.tween_property(bgm, "volume_db", -22.148, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

		emit_signal("AnimationFinished")
	if anime == "revolver":
		print("Animation: revolver")
		thereWasAnimation = false
		Globals.STOPHOVER = true
		print("Globals.STOPHOVER set to true")
		
		turnOffLightsRevolver(10)
		await get_tree().create_timer(1.0).timeout
		
		if (who == "ai" and revolverPos == "player") or (who == "player" and revolverPos == "ai"):
			print("Revolver needs to turn")
			
			if who == "ai" and revolverPos == "player":
				print("Playing animation: turnAi")
				$AnimationPlayer.play("turnAi")
			elif who == "player" and revolverPos == "ai":
				print("Playing animation: turnPlayer")
				$AnimationPlayer.play("turnPlayer")
				revolverPos = who
			await get_tree().create_timer(1.0).timeout
			print("Updated revolverPos to:", revolverPos)
			thereWasAnimation = true
			
		if who == "ai":
			print("Playing animation: revolverOutAI")
			$AnimationPlayer.play("revolverOutAI")
		if who == "player":
			print("Playing animation: revolverOutPlayer")
			$AnimationPlayer.play("revolverOutPlayer")
		await get_tree().create_timer(1.0).timeout
		if what == "Bullet":
			print("There was a bullet!")
			if who == "ai":
				print("Playing animation: aiShot")
				$AnimationPlayer.play("aiShot")
			elif who == "player":
				print("Playing animation: playerShot")
				$AnimationPlayer.play("playerShot")
		
		if what == "noBullet":
			print("No bullet in chamber.")
			if who == "ai":
				print("Playing animation: aiFake")
				$AnimationPlayer.play("aiFake")
			elif who == "player":
				print("Playing animation: playerFake")
				$AnimationPlayer.play("playerFake")
		await get_tree().create_timer(9.0).timeout
		if revolverPos == "ai":
			print("Putting revolver back into AI")
			$AnimationPlayer.play("revolverInAI")
		elif revolverPos == "player":
			print("Putting revolver back into Player")
			$AnimationPlayer.play("revolverInPlayer")
		
		Globals.STOPHOVER = false
		print("Globals.STOPHOVER set to false")

func turnOffLightsRevolver(timeWaiting):
	var tween = get_tree().create_tween()
	var bgm = $"../SoundManager/BGM"
	tween.tween_property(bgm, "volume_db", -40, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	emit_signal("callSoundManager", "lightOff")
	await get_tree().create_timer(0.2).timeout
	
	for i in $"../CardManager".get_children():
		i.visible = false
	for i in $"../iaHand".get_children():
		i.visible = false
	for i in $"../playerHand".get_children():
		i.visible = false
	
	var savedColour = $"../CanvasModulate".color
	$"../CanvasModulate".color = Color.BLACK
	
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/SpotP1".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/FireP1".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/SpotP2".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/FireP2".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/SpotP3".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/FireP3".visible = false

	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/SpotA1".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/FireA1".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/SpotA2".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/FireA2".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/SpotA3".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/FireA3".visible = false

	$"../PlayerTurnLight".visible = false
	$"../AiTurnLight".visible = false
		
	$"../PointLight2D".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/SpotLight3D".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/RevolverLight".visible = true

	await get_tree().create_timer(timeWaiting).timeout

	emit_signal("callSoundManager", "lightOn")
	await get_tree().create_timer(0.1).timeout

	for i in $"../iaHand".get_children():
		i.visible = true
	for i in $"../playerHand".get_children():
		i.visible = true

	$"../CanvasModulate".color = savedColour
	$"../3DViewport/SubViewportContainer/SubViewport/SpotLight3D".visible = true
	$"../3DViewport/SubViewportContainer/SubViewport/RevolverLight".visible = true
	$"../PointLight2D".visible = true

	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/SpotP1".visible = true
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/FireP1".visible = true
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/SpotP2".visible = true
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/FireP2".visible = true
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/SpotP3".visible = true
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/FireP3".visible = true

	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/SpotA1".visible = true
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/FireA1".visible = true
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/SpotA2".visible = true
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/FireA2".visible = true
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/SpotA3".visible = true
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/FireA3".visible = true


	# Fade BGM back in
	var tween2 = create_tween()
	tween2.tween_property(bgm, "volume_db", -22.148, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
