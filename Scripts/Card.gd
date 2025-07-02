extends Node2D

signal hovered
signal hovered_off
@export var max_offset_shadow: float = 50.0
@onready var shadow = $Shadow
var position_in_hand
var hovered_shadow = false

func _ready() -> void:
	get_parent().connect_card_signals(self)


func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)
	hovered_shadow = true

func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)
	hovered_shadow = false
