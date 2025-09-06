extends Label

var debt

func _on_game_manager_calculate_debt() -> void:
	debt = $"../../GameManager".neededMoney - $"../../GameManager".money
	if debt > 0:
		self.text = tr("game_text_debt") + format_money(debt) + "$"
	elif Globals.debtLost == true:	
		self.text = "INFO. CLASSIFICADA"
	else:
		debt *= -1
		self.text = tr("game_text_debt1") + format_money(debt) + "$"

func _on_game_manager_call_typing() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "visible_ratio", 1.0, 3.0).from(0.0)

func format_money(value: int) -> String:
	var s := str(value)
	var result := ""
	var count := 0
	for i in range(s.length() - 1, -1, -1):
		result = s[i] + result
		count += 1
		if count % 3 == 0 and i != 0:
			result = "." + result
	return result
