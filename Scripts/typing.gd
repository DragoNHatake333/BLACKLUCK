extends Label

func call_typing():
	var tween: Tween = create_tween()
	tween.tween_property(self, "visible_ratio", 1.0, 3.0).from(0.0)
