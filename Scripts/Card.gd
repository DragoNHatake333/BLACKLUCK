class_name Card
extends Area2D

@export var drag_enabled: bool = true

var _dragging := false
var _drag_offset := Vector2.ZERO
var _mouse_inside := false
var _original_position := Vector2.ZERO
static var _hovered_card: Card = null
static var _z_counter := 1  # Tracks the top z_index

func _ready():
	input_pickable = true
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	_original_position = global_position  # Save start position

func _on_mouse_entered():
	_mouse_inside = true
	_hovered_card = self

func _on_mouse_exited():
	_mouse_inside = false
	if _hovered_card == self:
		_hovered_card = null

func _input_event(viewport, event, shape_idx):
	if not drag_enabled or _hovered_card != self:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_start_drag(event.position)
	elif event is InputEventScreenTouch and event.pressed:
		_start_drag(event.position)

func _unhandled_input(event):
	if _dragging:
		if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed) \
		or (event is InputEventScreenTouch and not event.pressed):
			_stop_drag()

func _process(_delta):
	if _dragging:
		global_position = get_global_mouse_position() - _drag_offset

func _start_drag(mouse_position: Vector2):
	_dragging = true
	_drag_offset = mouse_position - global_position
	_z_counter += 1
	z_index = _z_counter  # Bring to front

func _stop_drag():
	_dragging = false

	var space_state = get_world_2d().direct_space_state
	var query := PhysicsPointQueryParameters2D.new()
	query.position = global_position
	query.collide_with_areas = true
	query.exclude = [self]

	var result = space_state.intersect_point(query)

	var dropped_in_hand := false

	for res in result:
		if res.collider and res.collider.has_method("is_player_hand_area") and res.collider.is_player_hand_area():
			if not Globals.playerHand.has(name):
				Globals.playerHand.append(name)
				print("Card dropped in player hand:", name)
			dropped_in_hand = true
			break

	if not dropped_in_hand:
		global_position = _original_position  # Snap back
