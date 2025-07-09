extends PointLight2D

func _process(_delta: float) -> void:
	self.position = get_global_mouse_position()
