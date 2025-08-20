# settings_menu.gd
extends PanelContainer

# Volumen
@onready var volume_slider = $Panel/VBoxContainer/VBoxContainer/HBoxContainer/MasterSlider # Usar % para rutas de nodo relativas si están en la misma escena
@onready var volume_label = $Panel/VBoxContainer/VBoxContainer/HBoxContainer/VolumeLabel

@onready var music_slider = $Panel/VBoxContainer/VBoxContainer/HBoxContainer2/MusicSlider
@onready var music_label = $Panel/VBoxContainer/VBoxContainer/HBoxContainer2/MusicLabel

@onready var sfx_slider = $Panel/VBoxContainer/VBoxContainer/HBoxContainer3/SFXSlider
@onready var sfx_label = $Panel/VBoxContainer/VBoxContainer/HBoxContainer3/SFXLabel
@onready var click_sound = $"../ClickSound"
# Idioma
@onready var language_option = $Panel/VBoxContainer/VBoxContainer/HBoxContainer4/LanguageOptionsButton
const LANGUAGE_CODES := ["en", "es", "ca"]
const SETTINGS_FILE := "user://settings.cfg"

# Botón de regreso
@onready var back_button = $Panel/VBoxContainer/VBoxContainer/VBoxContainer2/Back # Asegúrate de que este nodo exista en tu escena SettingsMenu
@onready var quit_button = $Panel/VBoxContainer/VBoxContainer/VBoxContainer2/Quit # Asumiendo que este es el botón "Salir del Juego"

# Variables de control
var _target_volume := 1.0
var _current_volume := 1.0
var _fade_speed := 5.0
var _is_dragging_volume := false

# Señal para notificar que la configuración se cerró
signal settings_closed

func _ready():
	_load_settings()
	if OS.has_feature("web"):
		quit_button.visible = false

	# Conectar sliders
	volume_slider.value_changed.connect(_on_volume_changed)
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)

	# Conectar selección de idioma
	language_option.item_selected.connect(_on_language_selected)

	# Conectar el botón de regreso de la configuración
	back_button.pressed.connect(_on_back_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
func _unhandled_input(event):
	# Si estás arrastrando el slider maestro para que la lógica de fading funcione
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and volume_slider.get_global_rect().has_point(get_global_mouse_position()):
			_is_dragging_volume = true
		elif not event.pressed and _is_dragging_volume:
			_is_dragging_volume = false
			_apply_volume("Master", volume_slider.value)


func _process(delta):
	# Lógica para el fade de volumen maestro
	if not _is_dragging_volume and abs(_current_volume - _target_volume) > 0.001:
		_current_volume = lerp(_current_volume, _target_volume, delta * _fade_speed)
	else:
		_current_volume = _target_volume

	var clamped_volume = max(_current_volume, 0.01)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(clamped_volume))
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), _current_volume <= 0.01)


# ==========================
#   GUARDAR / CARGAR DATOS
# ==========================
func _save_settings():
	var cfg := ConfigFile.new()
	cfg.set_value("Audio", "master", volume_slider.value)
	cfg.set_value("Audio", "music", music_slider.value)
	cfg.set_value("Audio", "sfx", sfx_slider.value)
	cfg.set_value("Language", "language", LANGUAGE_CODES[language_option.get_selected_id()])
	cfg.save(SETTINGS_FILE)

func _normalize_locale(locale: String) -> String:
	return locale.substr(0, 2)

func _load_settings():
	var cfg := ConfigFile.new()
	if cfg.load(SETTINGS_FILE) == OK:
		var master = cfg.get_value("Audio", "master", 1.0)
		var music = cfg.get_value("Audio", "music", 1.0)
		var sfx = cfg.get_value("Audio", "sfx", 1.0)
		var language = cfg.get_value("Language", "language", OS.get_locale())

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

		var lang = _normalize_locale(language)
		_set_language(lang)
		var idx = LANGUAGE_CODES.find(lang)
		if idx != -1:
			language_option.select(idx)
	else:
		volume_slider.value = 1.0
		music_slider.value = 1.0
		sfx_slider.value = 1.0

		var sys_lang = _normalize_locale(OS.get_locale())
		_set_language(sys_lang)

		var idx = LANGUAGE_CODES.find(sys_lang)
		if idx != -1:
			language_option.select(idx)
		else:
			language_option.select(0) # Default to English if system language not found

		_save_settings()


# ==========================
#   AUDIO
# ==========================
func _on_volume_changed(value):
	volume_label.text = "%d%%" % int(round(value * 100))
	if not _is_dragging_volume:
		_target_volume = value
		_save_settings()


func _on_music_volume_changed(value):
	music_label.text = "%d%%" % int(round(value * 100))
	_apply_volume("Music", value)
	_save_settings()


func _on_sfx_volume_changed(value):
	sfx_label.text = "%d%%" % int(round(value * 100))
	_apply_volume("SFX", value)
	_save_settings()


func _apply_volume(bus_name: String, value: float):
	var index = AudioServer.get_bus_index(bus_name)
	if index == -1:
		push_warning("Audio bus '%s' not found!" % bus_name)
		return
	var db = linear_to_db(max(value, 0.01))
	AudioServer.set_bus_volume_db(index, db)
	AudioServer.set_bus_mute(index, value <= 0.01)

# ==========================
#   BOTONES (específicos de SettingsMenu)
# ==========================
func _on_back_pressed():
	# Puedes emitir una señal aquí para que el MainMenu o PauseMenu sepan que la configuración se cerró
	settings_closed.emit()
	queue_free() # Elimina esta escena de la jerarquía cuando se presiona el botón de regreso

# ==========================
#   IDIOMA
# ==========================
func _on_language_selected(index: int) -> void:
	var language: String = LANGUAGE_CODES[index]
	_set_language(language)
	_save_settings()


func _set_language(language: String) -> void:
	TranslationServer.set_locale(language)

func _on_quit_pressed():
	click_sound.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()
