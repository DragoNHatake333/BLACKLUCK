extends Control

var transitioning := false
var mouse
var settings_instance: Node = null 
@onready var settingsbtn = $PanelContainer/VBoxContainer/OptionsButton
@onready var resumebtn = $PanelContainer/VBoxContainer/Resume
@onready var mainmenubtn = $"PanelContainer/VBoxContainer/Main Menu"
@onready var click_sound = $ClickSound
const SETTINGS_SCENE := preload("res://Scenes/settings_menu.tscn")

func _ready() -> void:
	hide()
	var window = get_window()
	window.focus_exited.connect(_on_focus_exited)
	settingsbtn.pressed.connect(_on_settings_pressed)
func resume():
	if transitioning:
		return
	transitioning = true
	Globals.canvasModulate = true
	get_tree().paused = false
	await get_tree().create_timer(0.01).timeout
	$AnimationPlayer.play_backwards("blur")
	await get_tree().create_timer(0.3).timeout
	hide()
	if mouse == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Globals.isCardDragging = false
	transitioning = false

func pause():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if transitioning:
		return
	transitioning = true
	show()
	Globals.canvasModulate = false
	#await get_tree().create_timer(0.01).timeout
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	await get_tree().create_timer(0.3).timeout
	transitioning = false

func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused and !Globals.startanim:
		# 🔥 abrir el menú de pausa
		if Globals.isCardDragging == true:
			Globals.releaseCardMenu = true
		mouse = Input.get_mouse_mode() != Input.MOUSE_MODE_HIDDEN
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		# 🔥 cerrar TODO y volver al juego
		_close_all_and_resume()

func _on_resume_pressed():
	resume()

func _on_quit_pressed():
	get_tree().paused = false
	SceneManager.change_scene("res://Scenes/MainMenu/Scenes/MainMenu.tscn")

func _on_main_menu_pressed() -> void:
	_on_quit_pressed()

func _process(_delta):
	testEsc()

func _on_focus_exited():
	if !get_tree().paused and !Globals.startanim:
		if Globals.isCardDragging == true:
			Globals.releaseCardMenu = true
		pause()
	else:
		pass

func _on_settings_pressed():
	# Instancia escena de settings
	settings_instance = SETTINGS_SCENE.instantiate()
	settings_instance.from_pause = true
	# Conectar señal
	settings_instance.settings_closed.connect(_on_settings_closed)
	# Settings como hijo del pause menu
	add_child(settings_instance)
	resumebtn.hide()
	settingsbtn.hide()
	mainmenubtn.hide()

func _on_settings_closed(reopen_pause: bool):
	if settings_instance and is_instance_valid(settings_instance):
		settings_instance.queue_free()
		settings_instance = null

	resumebtn.show()
	settingsbtn.show()
	mainmenubtn.show()

	if reopen_pause:
		# 🔥 Solo volvemos al Pause (sigue pausado)
		show()
	else:
		# 🔥 Cerramos todo y reanudamos
		_close_all_and_resume()

func _close_all_and_resume():
	# Si hay un settings abierto, lo cerramos
	if settings_instance and is_instance_valid(settings_instance):
		settings_instance.queue_free()
		settings_instance = null

	# Restauramos botones principales
	resumebtn.show()
	settingsbtn.show()
	mainmenubtn.show()

	# Reanudamos el juego
	resume()

	# 🔥 Ocultamos el menú de pausa por completo
	hide()
