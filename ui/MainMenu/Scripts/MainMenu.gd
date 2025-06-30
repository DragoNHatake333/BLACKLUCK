extends Control

@onready var play_button = $VBoxContainer/PlayButton
@onready var settings_button = $VBoxContainer/OptionsButton
@onready var quit_button = $VBoxContainer/QuitButton
@onready var settings_panel = $OptionsPanel
@onready var menu_buttons = $VBoxContainer
@onready var title_label = $Blackluck

# Volumen
@onready var click_sound = $ClickSound
@onready var volume_slider = $OptionsPanel/VBoxContainer/TabContainer/Audio/VBoxContainer/HBoxContainer/MasterSlider
@onready var volume_label = $OptionsPanel/VBoxContainer/TabContainer/Audio/VBoxContainer/HBoxContainer/VolumeLabel
var _target_volume := 1.0
var _current_volume := 1.0
var _fade_speed := 5.0
var _last_percent_displayed := -1
var _is_dragging_volume := false

# Gráficos
@onready var window_mode_label = $OptionsPanel/VBoxContainer/TabContainer/Graphics/VBoxContainer/WindowModeVBoxContainer/WindowModeLabel
@onready var display_monitor_label = $OptionsPanel/VBoxContainer/TabContainer/Graphics/VBoxContainer/DisplayMonitorVBoxContainer/DisplayMonitorLabel
@onready var apply_button = $OptionsPanel/VBoxContainer/TabContainer/Graphics/VBoxContainer/ApplyContainer/Apply
@onready var display_left_button = $OptionsPanel/VBoxContainer/TabContainer/Graphics/VBoxContainer/DisplayMonitorVBoxContainer/DisplayMonitorLeftButton
@onready var display_right_button = $OptionsPanel/VBoxContainer/TabContainer/Graphics/VBoxContainer/DisplayMonitorVBoxContainer/DisplayMonitorRightButton

var window_modes := ["Windowed", "Fullscreen", "Borderless"]
var window_mode_index := 1
var display_index := 0
var _last_screen_count := DisplayServer.get_screen_count()

func _ready():
	if OS.has_feature("web"):
		quit_button.visible = false

	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	$OptionsPanel/VBoxContainer/Back.pressed.connect(_on_back_pressed)
	volume_slider.value_changed.connect(_on_volume_changed)
	apply_button.pressed.connect(_on_apply_pressed)

	var vol = ProjectSettings.get_setting("application/config/volume", 0.5)
	volume_slider.value = vol
	_apply_volume(vol)
	volume_label.text = "%d%%" % int(round(vol * 100))
	_current_volume = vol
	_target_volume = vol
	_last_percent_displayed = int(round(vol * 100))

	display_index = DisplayServer.window_get_current_screen()
	_update_graphics_labels()
	_update_monitor_buttons()

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

	var current_screen_count = DisplayServer.get_screen_count()
	if current_screen_count != _last_screen_count:
		_last_screen_count = current_screen_count
		_update_monitor_buttons()

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
	get_tree().change_scene_to_file("res://Table.tscn")

func _on_settings_pressed():
	click_sound.play()
	settings_panel.visible = true
	title_label.visible = false
	menu_buttons.visible = false

func _on_quit_pressed():
	click_sound.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()

func _on_back_pressed():
	click_sound.play()
	settings_panel.visible = false
	menu_buttons.visible = true
	title_label.visible = true

func _update_graphics_labels():
	var mode = window_modes[window_mode_index]
	window_mode_label.text = " %s " % mode
	display_monitor_label.text = " %d " % [display_index + 1]

func _on_apply_pressed():
	click_sound.play()
	match window_modes[window_mode_index]:
		"Windowed":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		"Borderless":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		"Fullscreen":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)

	display_index = clamp(display_index, 0, DisplayServer.get_screen_count() - 1)
	DisplayServer.window_set_current_screen(display_index)
	_update_graphics_labels()

func _on_display_monitor_left_button_pressed() -> void:
	click_sound.play()
	if display_index > 0:
		display_index -= 1
		_update_graphics_labels()
		_update_monitor_buttons()

func _on_display_monitor_right_button_pressed() -> void:
	click_sound.play()
	var screen_count = DisplayServer.get_screen_count()
	if display_index < screen_count - 1:
		display_index += 1
		_update_graphics_labels()
		_update_monitor_buttons()

func _on_window_mode_left_button_pressed() -> void:
	click_sound.play()
	window_mode_index = (window_mode_index - 1 + window_modes.size()) % window_modes.size()
	_update_graphics_labels()

func _on_window_mode_right_button_pressed() -> void:
	click_sound.play()
	window_mode_index = (window_mode_index + 1) % window_modes.size()
	_update_graphics_labels()

func _on_tab_container_tab_changed(_tab_index: int) -> void:
	if $ClickSound.is_inside_tree():
		$ClickSound.play()

func _update_monitor_buttons():
	var screen_count = DisplayServer.get_screen_count()

	# Si solo hay una pantalla, desactivar ambos
	if screen_count <= 1:
		display_left_button.disabled = true
		display_right_button.disabled = true
		return

	# Lógica según el índice actual
	display_left_button.disabled = display_index <= 0
	display_right_button.disabled = display_index >= screen_count - 1
