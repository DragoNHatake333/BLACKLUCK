extends Node2D


const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT = 2
var screenSize
var cardBeingDrag
var is_hovering_on_card
var center_hand_reference
const DEFAULT_CARD_MOVE_SPEED = 0.1
@export var angle_x_max: float = 15.0
@export var angle_y_max: float = 15.0
@export var max_offset_shadow: float = 50.0

var drag_offset := Vector2.ZERO

signal callCardSlot
var mouse_pos = get_global_mouse_position()

func _ready() -> void:
	screenSize = get_viewport_rect().size
	center_hand_reference = $"../CenterHand"
	$"../InputManager".connect("left_mouse_button_released", on_left_click_released)

func on_left_click_released():
	if cardBeingDrag:
		finish_drag()

func _process(_delta: float) -> void:
	mouse_pos = get_global_mouse_position()
	if cardBeingDrag:
		var new_pos = mouse_pos + drag_offset
		cardBeingDrag.global_position = Vector2(
			clamp(new_pos.x, 0, screenSize.x),
			clamp(new_pos.y, 0, screenSize.y)
		)

func start_drag(card):
	cardBeingDrag = card
	drag_offset = card.global_position - get_global_mouse_position()
	card.scale = Vector2(1, 1)
	card.z_index = 25

func finish_drag():
	cardBeingDrag.scale = Vector2(1.05, 1.05)

	var card_slot_found = raycast_slot()
	if card_slot_found and not card_slot_found.card_in_slot:
		center_hand_reference.remove_card_from_hand(cardBeingDrag)
		cardBeingDrag.global_position = card_slot_found.global_position
		cardBeingDrag.get_node("Area2D/CollisionShape2D").disabled = true
		card_slot_found.card_in_slot = true
		card_slot_found.card_name = cardBeingDrag.name
		emit_signal("callCardSlot")
	else:
		center_hand_reference.add_card_to_hand(cardBeingDrag, DEFAULT_CARD_MOVE_SPEED)
	cardBeingDrag = null
	
func raycast():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_card_high_z(result)
	return null

func raycast_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null

func get_card_high_z(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	for i in range (1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card

func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)

func on_hovered_over_card(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card, true)
	
func on_hovered_off_card(card):
	if !cardBeingDrag:
		is_hovering_on_card = false
		highlight_card(card, false)
		var new_card_hovered = raycast()
		if new_card_hovered:
			highlight_card(new_card_hovered, true)
		else:
			is_hovering_on_card = false

func highlight_card(card, hovered):
	if hovered:
		var tween_hover = create_tween()
		tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
		tween_hover.tween_property(card, "scale", Vector2(1.05, 1.05), 0.3)
		#card.scale = Vector2(1.05, 1.05)
		card.z_index = 2
	else:
		var tween_hover = create_tween()
		tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
		tween_hover.tween_property(card, "scale", Vector2(1, 1), 0.3)
		#card.scale = Vector2(1.05, 1.05)
		card.z_index = 2
