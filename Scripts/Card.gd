extends Node2D

signal hovered
signal hovered_off

@export var max_offset_shadow: float = 50.0

var position_in_hand
var hovered_shadow = false

func _ready() -> void:
	get_parent().connect_card_signals(self)
	randomize()

	var rotation_degrees := 0.0
	if randf() > 0.15:
		rotation_degrees = randf_range(-5.0, 5.0)
		if randf() < 0.1:
			rotation_degrees += 180.0

	var target_rotation = deg_to_rad(rotation_degrees)
	$CardImage.rotation = 0.0  # Start from zero

	var tween = create_tween()
	var track = tween.tween_property($CardImage, "rotation", target_rotation, 0.4)
	track.set_trans(Tween.TRANS_SINE)
	track.set_ease(Tween.EASE_OUT)

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)
	hovered_shadow = true

func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)
	hovered_shadow = false
