extends Sprite2D

@onready var tween := create_tween()

func _ready():
	# Start the breathing loop
	start_breathing()

func start_breathing():
	tween.kill() # Clear old tweens
	tween = create_tween()
	tween.set_loops() # loop forever

	# Fade out (alpha 1 → 0.3 over 1s)
	tween.tween_property(self, "modulate:a", 0.3, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	# Fade in (alpha 0.3 → 1 over 1s)
	tween.tween_property(self, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await get_tree().create_timer(2.0).timeout
	start_breathing()
