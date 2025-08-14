extends Label

func _on_game_manager_rollcredits() -> void:
	var tween: Tween = create_tween()

	# Tweenea la posición Y desde donde esté hasta -altura del Label (sale por arriba)
	tween.tween_property(
		self,
		"position:y",
		-size.y, # sale por la parte superior
		100     # duración en segundos
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
