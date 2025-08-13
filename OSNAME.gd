extends Label


var username


func _ready() -> void:
	var username = ""
	if OS.has_environment("USERNAME"): # Windows
		username = OS.get_environment("USERNAME")
	elif OS.has_environment("USER"): # Linux / macOS
		username = OS.get_environment("USER")
	else:
		username = "Player"
	
	self.text = username

func _on_game_manager_call_typing() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "visible_ratio", 1.0, 3.0).from(0.0)
