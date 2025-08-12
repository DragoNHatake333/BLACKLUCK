extends Sprite2D

@export var step_angle: float = 60.0   # degrees per step
@export var step_time: float = 0.5    # seconds to rotate each step
@export var pause_time: float = 1    # pause between steps

var target_rotation := 0.0

func _ready():
	rotate_next_step()

func rotate_next_step():
	target_rotation += step_angle
	var tween := create_tween()
	tween.tween_property(self, "rotation_degrees", target_rotation, step_time)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(Callable(self, "_on_rotation_complete"))

func _on_rotation_complete():
	# Wait before next rotation
	get_tree().create_timer(pause_time).timeout.connect(rotate_next_step)
