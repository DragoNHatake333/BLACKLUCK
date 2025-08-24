extends Node

# Carga de texturas personalizadas
var hand_open   = load("res://Assets/hand2.png")
var hand_closed = load("res://Assets/handclosed.png")

var click_timer: Timer

func _ready() -> void:
	# Cursor por defecto = mano abierta
	Input.set_custom_mouse_cursor(hand_open, Input.CURSOR_ARROW, Vector2(16, 16))

	# Timer para detectar "click sostenido"
	click_timer = Timer.new()
	click_timer.wait_time = 1.0
	click_timer.one_shot = true
	click_timer.timeout.connect(_on_click_timeout)
	add_child(click_timer)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			# Click → mano cerrada
			Input.set_custom_mouse_cursor(hand_closed, Input.CURSOR_ARROW, Vector2(16, 16))
			click_timer.start()
		else:
			# Soltar → vuelve a mano abierta
			Input.set_custom_mouse_cursor(hand_open, Input.CURSOR_ARROW, Vector2(16, 16))
			click_timer.stop()

func _on_click_timeout() -> void:
	# Si aún está presionado tras 1s → mano de “sostener”
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.set_custom_mouse_cursor(hand_closed, Input.CURSOR_ARROW, Vector2(16, 16))
