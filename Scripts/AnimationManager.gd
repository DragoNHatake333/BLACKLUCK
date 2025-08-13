extends Node
signal AnimationFinished
signal RevolverFinished
signal callSoundManager
signal turnFinished
signal outFinished
signal clickFinished
signal inFinished
var revolverPos = "player"
@onready var revolver = $"../3DViewport/SubViewportContainer/SubViewport/Sketchfab_Scene"
var savedColour
@onready var bgm = $"../SoundManager/BGM"
var is_animating
#@onready var revolverLight = $"../3DViewport/SubViewportContainer/SubViewport/RevolverLight"

func callAnimationManager(anime, who, what) -> void:
	if anime == "candle":
		var tween = create_tween()
		
		# Fade out BGM
		tween.tween_property(bgm, "volume_db", -100, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
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

		if Globals.playerHP == 0 or Globals.aiHP == 0:
			$"../Start/BlackBackground".visible = true
			Globals.canvasModulate = false
			var tween2 = create_tween()
			emit_signal("AnimationFinished")
			return
		
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
		
		if Globals.playerHP == 3:
			$"../SoundManager/BGM".stream = load("res://Assets/Sound/loops/1.mp3")
			bgm.play()
			$"../CanvasLayer/ColorRect".material.set_shader_parameter("wiggleMult", 0.0015)
			$"../CanvasLayer/ColorRect".material.set_shader_parameter("chromaticAberrationOffset", 0.001)
		if Globals.playerHP == 2:
			$"../SoundManager/BGM".stream = load("res://Assets/Sound/loops/2.mp3")
			bgm.play()
			$"../CanvasLayer/ColorRect".material.set_shader_parameter("wiggleMult", 0.0030)
			$"../CanvasLayer/ColorRect".material.set_shader_parameter("chromaticAberrationOffset", 0.002)
		if Globals.playerHP == 1:
			$"../SoundManager/BGM".stream = load("res://Assets/Sound/loops/3.mp3")
			bgm.play()
			$"../CanvasLayer/ColorRect".material.set_shader_parameter("wiggleMult", 0.0045)
			$"../CanvasLayer/ColorRect".material.set_shader_parameter("chromaticAberrationOffset", 0.004)
			
		# Fade BGM back in
		var tween2 = create_tween()
		tween2.tween_property(bgm, "volume_db", -15.215, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

		emit_signal("AnimationFinished")
	if anime == "revolver":
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		Globals.STOPHOVER = true
		print("Animation: revolver")
		print("Globals.STOPHOVER set to true")
		
		turnOffLightsRevolver()
		
		await get_tree().create_timer(2.0).timeout
		
		if (who == "ai" and revolverPos == "player") or (who == "player" and revolverPos == "ai"):
			print("Revolver needs to turn")
			
			if who == "ai" and revolverPos == "player":
				print("Playing animation: turnAi")
				$AnimationPlayer.play("turnAi")
			elif who == "player" and revolverPos == "ai":
				print("Playing animation: turnPlayer")
				$AnimationPlayer.play("turnPlayer")
			revolverPos = who
			print("Updated revolverPos to: ", revolverPos)
			await turnFinished
			
		if who == "ai":
			print("Playing animation: revolverOutAI")
			$AnimationPlayer.play("revolverOutAI")
		elif who == "player":
			print("Playing animation: revolverOutPlayer")
			$AnimationPlayer.play("revolverOutPlayer")
			
		await outFinished
		
		if what == "bullet":
			print("There was a bullet!")
			if who == "ai":
				print("Playing animation: aiShot")
				$AnimationPlayer.play("aiShot")
			elif who == "player":
				print("Playing animation: playerShot")
				$AnimationPlayer.play("playerShot")
		
		elif what == "noBullet":
			print("No bullet in chamber.")
			if who == "ai":
				print("Playing animation: aiFake")
				$AnimationPlayer.play("aiFake")
			elif who == "player":
				print("Playing animation: playerFake")
				$AnimationPlayer.play("playerFake")
		
		print("Waiting for click finished.")
		await clickFinished
		print("Continuing after await clickFinished.")
		
		if revolverPos == "ai":
			print("Putting revolver back into AI")
			$AnimationPlayer.play("revolverInAI")
		elif revolverPos == "player":
			print("Putting revolver back into Player")
			$AnimationPlayer.play("revolverInPlayer")
		
		await inFinished
		
		print("Globals.STOPHOVER set to false")
		await get_tree().create_timer(1.0).timeout
		turnOnLightsRevolver()
		emit_signal("RevolverFinished")
		Globals.STOPHOVER = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
func turnOffLightsRevolver():
	var tween = get_tree().create_tween()
	bgm = $"../SoundManager/BGM"
	tween.tween_property(bgm, "volume_db", -40, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	emit_signal("callSoundManager", "lightOff")
	await get_tree().create_timer(0.2).timeout
	
	for i in $"../CardManager".get_children():
		i.visible = false
	for i in $"../iaHand".get_children():
		i.visible = false
	for i in $"../playerHand".get_children():
		i.visible = false
	
	savedColour = $"../CanvasModulate".color
	$"../CanvasModulate".color = Color.BLACK
	
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/CandleP1".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP2/CandleP2".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP3/CandleP3".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA1/CandleA1".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA2/CandleA2".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA3/CandleA3".visible = false
	
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/SpotP1".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/FireP1".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP2/SpotP2".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP2/FireP2".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP3/SpotP3".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP3/FireP3".visible = false

	$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA1/SpotA1".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA1/FireA1".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA2/SpotA2".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA2/FireA2".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA3/SpotA3".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA3/FireA3".visible = false

	$"../PlayerTurnLight".visible = false
	$"../AiTurnLight".visible = false
		
	$"../PointLight2D".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/SpotLight3D".visible = false
	$"../3DViewport/SubViewportContainer/SubViewport/RevolverLight".visible = true
func turnOnLightsRevolver():
	if Globals.playerHP == 0 or Globals.aiHP == 0:
		$"../Start/BlackBackground".visible = true
		Globals.canvasModulate = false
		return
	
	emit_signal("callSoundManager", "lightOn")
	
	await get_tree().create_timer(0.1).timeout
	for i in $"../CardManager".get_children():
		i.visible = true
	for i in $"../iaHand".get_children():
		i.visible = true
	for i in $"../playerHand".get_children():
		i.visible = true
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP1/CandleP1".visible = true
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP2/CandleP2".visible = true
	$"../3DViewport/SubViewportContainer/SubViewport/PlayerCandles/CandleP3/CandleP3".visible = true
	$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA1/CandleA1".visible = true
	$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA2/CandleA2".visible = true
	$"../3DViewport/SubViewportContainer/SubViewport/AICandles/CandleA3/CandleA3".visible = true
	
	$"../CanvasModulate".color = savedColour
	$"../3DViewport/SubViewportContainer/SubViewport/SpotLight3D".visible = true
	$"../3DViewport/SubViewportContainer/SubViewport/RevolverLight".visible = true
	$"../PointLight2D".visible = true

	$"../GameManager".check_candle_lighting("check", "both")

	if Globals.playerHP == 3:
		$"../SoundManager/BGM".stream = load("res://Assets/Sound/loops/1.mp3")
		bgm.play()
		$"../CanvasLayer/ColorRect".material.set_shader_parameter("wiggleMult", 0.0015)
		$"../CanvasLayer/ColorRect".material.set_shader_parameter("chromaticAberrationOffset", 0.001)
	if Globals.playerHP == 2:
		$"../SoundManager/BGM".stream = load("res://Assets/Sound/loops/2.mp3")
		bgm.play()
		$"../CanvasLayer/ColorRect".material.set_shader_parameter("wiggleMult", 0.0030)
		$"../CanvasLayer/ColorRect".material.set_shader_parameter("chromaticAberrationOffset", 0.002)
	if Globals.playerHP == 1:
		$"../SoundManager/BGM".stream = load("res://Assets/Sound/loops/3.mp3")
		bgm.play()
		$"../CanvasLayer/ColorRect".material.set_shader_parameter("wiggleMult", 0.0045)
		$"../CanvasLayer/ColorRect".material.set_shader_parameter("chromaticAberrationOffset", 0.004)
	
	# Fade BGM back in
	var tween2 = create_tween()
	tween2.tween_property(bgm, "volume_db", -15.215, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _process(delta: float) -> void:
	$"../3DViewport/SubViewportContainer/SubViewport/RevolverLight".position.z = $"../3DViewport/SubViewportContainer/SubViewport/Sketchfab_Scene".position.z
	$"../3DViewport/SubViewportContainer/SubViewport/RevolverLight".position.x = $"../3DViewport/SubViewportContainer/SubViewport/Sketchfab_Scene".position.x
	Globals.is_animating = $AnimationPlayer.is_playing()
	if revolverPos == "ai":
		$"../RevolverButton/CollisionPolygon2D".position = Vector2(24.845, 897.945)
		$"../RevolverButton/CollisionPolygon2D".rotation_degrees = -143.5
	else:
		$"../RevolverButton/CollisionPolygon2D".position = Vector2(151.0, 274.0)
		$"../RevolverButton/CollisionPolygon2D".rotation_degrees = 0.0
