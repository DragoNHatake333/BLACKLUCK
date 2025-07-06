extends Node2D

signal left_mouse_button_clicked
signal left_mouse_button_released

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_DECK = 4

var card_manager_reference
var deck_reference


@onready var subviewport := $"../3DViewport/SubViewportContainer/SubViewport"
@onready var camera := $"../3DViewport/SubViewportContainer/SubViewport/Camera3D"
@onready var light := $"../3DViewport/SubViewportContainer/SubViewport/SpotLight3D"

func _process(delta):
	if !subviewport or !camera or !light:
		return

	var mouse_pos = subviewport.get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_direction = camera.project_ray_normal(mouse_pos)

	var plane = Plane(Vector3.UP, 0)
	var hit_pos = plane.intersects_ray(ray_origin, ray_direction)

	if hit_pos != null:
		var current_y = light.global_position.y
		light.global_position = Vector3(hit_pos.x, current_y, hit_pos.z)

func _ready() -> void:
	card_manager_reference = $"../CardManager"
	deck_reference = $"../Deck"

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and Globals.playerTurn == true:
		if event.pressed:
			emit_signal("left_mouse_button_clicked")
			raycast_at_cursor()
		else:
			emit_signal("left_mouse_button_released")

func raycast_at_cursor():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		var result_collision_mask = result[0].collider.collision_mask
		if result_collision_mask == COLLISION_MASK_CARD:
			#Card clicked
			var card_found = result[0].collider.get_parent()
			if card_found:
				card_manager_reference.start_drag(card_found)
		elif result_collision_mask == COLLISION_MASK_DECK:
			#Deck clicked
			deck_reference.draw_card()
