extends Node2D

signal hovered
signal hovered_off

var position_in_hand

func _ready() -> void:
	#All cards must be childs of CardManager
	get_parent().connect_card_signals(self)


func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)


func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)
