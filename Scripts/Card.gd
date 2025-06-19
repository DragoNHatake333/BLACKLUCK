extends Area2D

var card_drag: Node2D = null
var drag_offset := Vector2.ZERO
var card_in_area = false
var original_pos = 0


func _ready() -> void:
	original_pos = global_position

func _process(delta: float) -> void:
	if card_drag and card_drag is Node2D:
		var mouse_pos = get_global_mouse_position()
		card_drag.global_position = mouse_pos + drag_offset

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast()
			if card:
				card_drag = card
				drag_offset = card.global_position - get_global_mouse_position()
		else:
			card_drag = null
		if card_in_area == false:
			self.position = original_pos

func raycast() -> Node2D:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		var collider = result[0].collider
		if collider is Area2D:
			return collider
	return null

var is_self_hovered := false

func _on_mouse_entered() -> void:
	if Globals.is_card_hover == false:
		self.scale = Vector2(0.42, 0.42)
		self.z_index = 2
		Globals.is_card_hover = true
		is_self_hovered = true

func _on_mouse_exited() -> void:
	if is_self_hovered:
		self.scale = Vector2(0.38, 0.38)
		self.z_index = 1
		Globals.is_card_hover = false
		is_self_hovered = false
