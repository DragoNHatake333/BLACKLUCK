extends Area2D

var current_drop_zone: Area2D = null
var dragging := false
var drag_offset := Vector2.ZERO
var original_position := Vector2.ZERO

func _ready():
	input_pickable = true
	original_position = global_position

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and Globals.playerTurn:
		dragging = event.pressed
		if dragging:
			drag_offset = global_position - get_global_mouse_position()
			z_index = 100
		else:
			z_index = 1
			_try_snap_to_drop_zone()

func _process(_delta):
	if dragging:
		global_position = get_global_mouse_position() + drag_offset

func _try_snap_to_drop_zone():
	for area in get_overlapping_areas():
		if not area.is_in_group("drop_zone"):
			continue
		if area.occupied and area.occupying_card != self:
			continue

		# Release previous drop zone
		if current_drop_zone and current_drop_zone != area:
			current_drop_zone.occupied = false
			current_drop_zone.occupying_card = null

		# Snap and claim new drop zone
		global_position = area.global_position
		current_drop_zone = area
		area.occupied = true
		area.occupying_card = self

		# Update hand states
		Globals.playerPickedCard = true

		for i in Globals.playerHand:
			if Globals.playerHand[i]["card"] == "":
				Globals.playerHand[i]["card"] = name
				break

		for k in Globals.centerHand:
			if Globals.centerHand[k]["card"] == name:
				Globals.centerHand[k]["card"] = ""
				break

		# Reparent under Player node
		var player_node = get_node_or_null("/root/Main/Player")
		if player_node:
			get_parent().remove_child(self)
			player_node.add_child(self)

		Globals.playerTurn = false
		print(Globals.playerHand)
		return

	# Fallback to current drop zone or original position
	global_position = current_drop_zone.global_position if current_drop_zone else original_position
