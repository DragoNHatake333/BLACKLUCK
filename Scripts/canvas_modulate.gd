extends CanvasModulate

func _process(delta: float) -> void:
	if Globals.canvasModulate == true:
		self.color = "222222"
	elif Globals.canvasModulate == false:
		self.color = "ffffff"
