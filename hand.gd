extends Sprite2D

func _process(delta: float) -> void:
	self.position = get_global_mouse_position()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
