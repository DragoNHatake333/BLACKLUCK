extends Node2D

signal hovered
signal hovered_off

@export var max_offset_shadow: float = 50.0

var position_in_hand
var hovered_shadow = false
var target_rotation

@onready var shadow = $shadow
@onready var card_image = $CardImage

func _ready() -> void:
	get_parent().connect_card_signals(self)
	randomize()

	# Initialize shadow as fully transparent
	shadow.modulate.a = 0.0

	# Random rotation tween
	var rotation_degrees := 0.0
	if randf() > 0.15:
		rotation_degrees = randf_range(-5.0, 5.0)
		if randf() < 0.1:
			rotation_degrees += 180.0

	target_rotation = deg_to_rad(rotation_degrees)
	card_image.rotation = 0.0

	var tween = create_tween()
	var track = tween.tween_property(card_image, "rotation", target_rotation, 0.4)
	track.set_trans(Tween.TRANS_SINE)
	track.set_ease(Tween.EASE_OUT)

func _process(_delta: float) -> void:
	$shadow.rotation = target_rotation
	var center: Vector2 = get_viewport_rect().size / 2.0
	var distancex: float = global_position.x - center.x
	var distancey: float = global_position.y - center.y
	
	$shadow.position.x = lerp(0.0, -sign(distancex) * max_offset_shadow, abs(distancex/(center.x))) * -1
	$shadow.position.y = lerp(0.0, -sign(distancey) * max_offset_shadow, abs(distancey/(center.y))) * -1
	
func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)
	hovered_shadow = true

	var tween = get_tree().create_tween()
	tween.tween_property(shadow, "modulate:a", 1.0, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)
	hovered_shadow = false

	var tween = get_tree().create_tween()
	tween.tween_property(shadow, "modulate:a", 0.0, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
