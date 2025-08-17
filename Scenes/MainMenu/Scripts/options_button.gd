extends Button

func _on_mouse_entered() -> void:
	var tween := get_tree().create_tween()
	# Replace $"Image" with the actual node path to your TextureRect or Sprite2D
	tween.tween_property($"../Cylinder", "scale", Vector2(0.4, 0.4), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_mouse_exited() -> void:
	var tween := get_tree().create_tween()
	# Replace $"Image" with the actual node path to your TextureRect or Sprite2D
	tween.tween_property($"../Cylinder", "scale", Vector2(0.364, 0.364), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
