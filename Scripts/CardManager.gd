extends Node2D


const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT = 2
var screenSize
var cardBeingDrag
var is_hovering_on_card
var center_hand_reference

func _ready() -> void:
	screenSize = get_viewport_rect().size
	center_hand_reference = $"../CenterHand"

func _process(delta: float) -> void:
	if cardBeingDrag:
		var mouse_pos = get_global_mouse_position()
		cardBeingDrag.position = Vector2(clamp(mouse_pos.x, 0, screenSize.x), clamp(mouse_pos.y, 0, screenSize.y))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast()
			if card:
				start_drag(card)
		else:
			if cardBeingDrag:
				finish_drag()

func start_drag(card):
	cardBeingDrag = card
	card.scale = Vector2(1, 1)
	
func finish_drag():
	cardBeingDrag.scale = Vector2(1.05, 1.05)
	var card_slot_found = raycast_slot()
	if card_slot_found and not card_slot_found.card_in_slot:
		center_hand_reference.remove_card_from_hand(cardBeingDrag)
		cardBeingDrag.position = card_slot_found.position
		cardBeingDrag.get_node("Area2D/CollisionShape2D").disabled = true
		card_slot_found.card_in_slot = true
	else:
		center_hand_reference.add_card_to_hand(cardBeingDrag)
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
		card.scale = Vector2(1.05, 1.05)
		card.z_index = 2
	else:
		card.scale = Vector2(1, 1)
		card.z_index = 1
