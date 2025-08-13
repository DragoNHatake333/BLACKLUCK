extends Label

func _ready() -> void:
	var date_str = Time.get_datetime_string_from_system() 
	# "2025-08-13 14:05:42"
	self.text = "LAST SEEN:\n" + date_str

func _on_game_manager_call_typing() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "visible_ratio", 1.0, 3.0).from(0.0)
