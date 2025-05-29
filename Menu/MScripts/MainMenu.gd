extends Control

@onready var play_button = $VBoxContainer/PlayButton
@onready var settings_button = $VBoxContainer/SettingsButton
@onready var quit_button = $VBoxContainer/QuitButton
@onready var settings_panel = $SettingsPanel
@onready var volume_slider = $SettingsPanel/VBoxContainer/HBoxContainer/VolumeSlider

func _ready():
	if OS.has_feature("web"):
		quit_button.visible = false
	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	$SettingsPanel/VBoxContainer/Back.pressed.connect(_on_back_pressed)
	volume_slider.value_changed.connect(_on_volume_changed)

	# Load saved volume or default
	var vol = ProjectSettings.get_setting("application/config/volume", 0.5)
	volume_slider.value = vol
	AudioServer.set_bus_volume_db(0, linear_to_db(vol))

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Table.tscn")

func _on_settings_pressed():
	settings_panel.visible = true

func _on_quit_pressed():
	get_tree().quit()

func _on_back_pressed():
	settings_panel.visible = false

func _on_volume_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	ProjectSettings.set_setting("application/config/volume", value)
	ProjectSettings.save()
