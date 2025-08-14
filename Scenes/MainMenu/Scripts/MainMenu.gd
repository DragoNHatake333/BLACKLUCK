extends Control

@onready var play_button = $PlayButton
@onready var settings_button = $OptionsButton
@onready var quit_button = $QuitButton
@onready var settings_panel = $OptionsPanel
@onready var title_label = $PlayButton
@onready var back_button = $OptionsPanel/Panel/VBoxContainer/Back

# Volumen
@onready var click_sound = $ClickSound

@onready var volume_slider = $OptionsPanel/Panel/VBoxContainer/Audio/VBoxContainer/HBoxContainer/MasterSlider
@onready var volume_label = $OptionsPanel/Panel/VBoxContainer/Audio/VBoxContainer/HBoxContainer/VolumeLabel

@onready var music_slider = $OptionsPanel/Panel/VBoxContainer/Audio/VBoxContainer/HBoxContainer2/MusicSlider
@onready var music_label = $OptionsPanel/Panel/VBoxContainer/Audio/VBoxContainer/HBoxContainer2/MusicLabel

@onready var sfx_slider = $OptionsPanel/Panel/VBoxContainer/Audio/VBoxContainer/HBoxContainer3/SFXSlider
@onready var sfx_label = $OptionsPanel/Panel/VBoxContainer/Audio/VBoxContainer/HBoxContainer3/SFXLabel

var on_settings = false

# Variables de control
var _target_volume := 1.0
var _current_volume := 1.0
var _fade_speed := 5.0
var _is_dragging_volume := false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if OS.has_feature("web"):
		quit_button.visible = false

	# Conectar botones
	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	back_button.pressed.connect(_on_back_pressed)

	# Conectar sliders
	volume_slider.value_changed.connect(_on_volume_changed)
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)

	# Cargar valores guardados
	var master = ProjectSettings.get_setting("application/config/volume", 1.0)
	var music = ProjectSettings.get_setting("application/config/music_volume", 1.0)
	var sfx = ProjectSettings.get_setting("application/config/sfx_volume", 1.0)

	volume_slider.value = master
	music_slider.value = music
	sfx_slider.value = sfx

	_apply_volume("Master", master)
	_apply_volume("Music", music)
	_apply_volume("SFX", sfx)

	volume_label.text = "%d%%" % int(round(master * 100))
	music_label.text = "%d%%" % int(round(music * 100))
	sfx_label.text = "%d%%" % int(round(sfx * 100))

	_current_volume = master
	_target_volume = master

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and volume_slider.get_global_rect().has_point(get_global_mouse_position()):
			_is_dragging_volume = true
		elif not event.pressed and _is_dragging_volume:
			_is_dragging_volume = false
			_apply_volume("Master", volume_slider.value)

func _process(delta):
	if not _is_dragging_volume and abs(_current_volume - _target_volume) > 0.001:
		_current_volume = lerp(_current_volume, _target_volume, delta * _fade_speed)
	else:
		_current_volume = _target_volume

	var clamped_volume = max(_current_volume, 0.01)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(clamped_volume))
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), _current_volume <= 0.01)

func _on_volume_changed(value):
	volume_label.text = "%d%%" % int(round(value * 100))
	if not _is_dragging_volume:
		_target_volume = value
		ProjectSettings.set_setting("application/config/volume", value)

func _on_music_volume_changed(value):
	music_label.text = "%d%%" % int(round(value * 100))
	_apply_volume("Music", value)
	ProjectSettings.set_setting("application/config/music_volume", value)

func _on_sfx_volume_changed(value):
	sfx_label.text = "%d%%" % int(round(value * 100))
	_apply_volume("SFX", value)
	ProjectSettings.set_setting("application/config/sfx_volume", value)

func _apply_volume(bus_name: String, value: float):
	var index = AudioServer.get_bus_index(bus_name)
	if index == -1:
		push_warning("Audio bus '%s' not found!" % bus_name)
		return
	var db = linear_to_db(max(value, 0.01))
	AudioServer.set_bus_volume_db(index, db)
	AudioServer.set_bus_mute(index, value <= 0.01)

func _on_play_pressed():
	click_sound.play()
	await get_tree().create_timer(0.2).timeout
	SceneManager.change_scene("res://Scenes/loading_screen.tscn")

func _on_settings_pressed():
	if !on_settings:
		click_sound.play()
		title_label.visible = false
		settings_panel.visible = true
		on_settings = true
	elif on_settings:
		click_sound.play()
		settings_panel.visible = false
		title_label.visible = true
		on_settings = false
		
func _on_quit_pressed():
	pass
	#click_sound.play()
	#await get_tree().create_timer(0.2).timeout
	#get_tree().quit()

func _on_back_pressed():
	click_sound.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()
	#ANTES DE QUE LO TOCARA YO
	#click_sound.play()
	#settings_panel.visible = false
	#title_label.visible = true

func _on_tab_container_tab_changed(_tab_index: int) -> void:
	if click_sound.is_inside_tree():
		click_sound.play()
