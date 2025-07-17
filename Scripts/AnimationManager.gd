extends Node
signal AnimationFinished
signal callSoundManager

func anime_playerRevolver() -> void:
	pass # Replace with function body.


func callAnimationManager(anime, who) -> void:
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
