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
var _target_volume := 1.0
var _current_volume := 1.0
var _fade_speed := 5.0
var _last_percent_displayed := -1
var _is_dragging_volume := false

func _ready():
	if OS.has_feature("web"):
		quit_button.visible = false

	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	back_button.pressed.connect(_on_back_pressed)
	volume_slider.value_changed.connect(_on_volume_changed)

	var vol = ProjectSettings.get_setting("application/config/volume", 0.5)
	volume_slider.value = vol
	_apply_volume(vol)
	volume_label.text = "%d%%" % int(round(vol * 100))
	_current_volume = vol
	_target_volume = vol
	_last_percent_displayed = int(round(vol * 100))

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and volume_slider.get_global_rect().has_point(get_global_mouse_position()):
			_is_dragging_volume = true
		elif not event.pressed and _is_dragging_volume:
			_is_dragging_volume = false
			_apply_volume(volume_slider.value)

func _process(delta):
	if not _is_dragging_volume and abs(_current_volume - _target_volume) > 0.001:
		_current_volume = lerp(_current_volume, _target_volume, delta * _fade_speed)
	else:
		_current_volume = _target_volume

	var clamped_volume = max(_current_volume, 0.01)
	AudioServer.set_bus_volume_db(0, linear_to_db(clamped_volume))
	AudioServer.set_bus_mute(0, _current_volume <= 0.01)

func _on_volume_changed(value):
	var percent = int(round(value * 100))
	if percent != _last_percent_displayed:
		volume_label.text = "%d%%" % percent
		_last_percent_displayed = percent

	if not _is_dragging_volume:
		_apply_volume(value)

func _apply_volume(value: float):
	_target_volume = value
	ProjectSettings.set_setting("application/config/volume", value)

func _on_play_pressed():
	click_sound.play()
	await get_tree().create_timer(0.2).timeout
	SceneManager.change_scene("res://Scenes/Table.tscn")

func _on_settings_pressed():
	click_sound.play()
	settings_panel.visible = true
	title_label.visible = false

func _on_quit_pressed():
	click_sound.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()

func _on_back_pressed():
	click_sound.play()
	settings_panel.visible = false
	title_label.visible = true

func _on_tab_container_tab_changed(_tab_index: int) -> void:
	if click_sound.is_inside_tree():
		click_sound.play()
