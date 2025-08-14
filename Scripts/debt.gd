extends Label

var debt

func _on_game_manager_calculate_debt() -> void:
	debt = $"../../GameManager".neededMoney - $"../../GameManager".money
	if debt > 0:
		self.text = "DEBT: " + str(debt) + "$"
	elif Globals.debtLost == true:
		self.text = "INFO. CLASSIFICADA"
	else:
		debt *= -1
		self.text = "GAINS: " + str(debt) + "$"

func _on_game_manager_call_typing() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "visible_ratio", 1.0, 3.0).from(0.0)
