extends Area2D

@export_enum("player", "ai") var card_owner := "player"
const DropZone := preload("res://Scripts/drop_zone.gd")

var dragging := false
var drag_offset := Vector2.ZERO
var current_drop_zone: Area2D = null
var last_valid_position: Vector2 = Vector2.ZERO

func _ready():
	last_valid_position = global_position
	input_pickable = true

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and Globals.playerTurn:
		dragging = event.pressed
		drag_offset = global_position - get_global_mouse_position()
		z_index = 100 if dragging else 1
		if not dragging:
			_try_snap_to_drop_zone()

func _process(_delta):
	if dragging:
		global_position = get_global_mouse_position() + drag_offset

func _try_snap_to_drop_zone():
	for area in get_overlapping_areas():
		if area is DropZone and area.is_player_zone:
			if area.occupied and area.occupying_card != self:
				continue

			if current_drop_zone and current_drop_zone != area:
				current_drop_zone.occupied = false
				current_drop_zone.occupying_card = null

			global_position = area.global_position
			last_valid_position = global_position
			current_drop_zone = area
			area.occupied = true
			area.occupying_card = self

			_update_hand_assignment()
			_reparent_to_player()
			Globals.playerTurn = false
			return

	# Fallback to last valid
	global_position = last_valid_position

func _update_hand_assignment():
	var name = self.name
	for i in Globals.playerHand:
		if Globals.playerHand[i]["card"] == name:
			Globals.playerHand[i]["card"] = ""
	for i in Globals.playerHand:
		if Globals.playerHand[i]["card"] == "":
			Globals.playerHand[i]["card"] = name
			break
	for k in Globals.centerHand:
		if Globals.centerHand[k]["card"] == name:
			Globals.centerHand[k]["card"] = ""
			break

func _reparent_to_player():
	var player_node = get_node_or_null("/root/Main/Player")
	if player_node:
		get_parent().remove_child(self)
		player_node.add_child(self)

func _exit_tree():
	if current_drop_zone:
		current_drop_zone.occupied = false
		current_drop_zone.occupying_card = null
		current_drop_zone = null
