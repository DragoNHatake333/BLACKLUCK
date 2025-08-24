# settings_menu.gd
extends PanelContainer

# Volumen
@onready var volume_slider = $Panel/VBoxContainer/VBoxContainer/HBoxContainer/MasterSlider
@onready var volume_label = $Panel/VBoxContainer/VBoxContainer/HBoxContainer/VolumeLabel

@onready var music_slider = $Panel/VBoxContainer/VBoxContainer/HBoxContainer2/MusicSlider
@onready var music_label = $Panel/VBoxContainer/VBoxContainer/HBoxContainer2/MusicLabel

@onready var sfx_slider = $Panel/VBoxContainer/VBoxContainer/HBoxContainer3/SFXSlider
@onready var sfx_label = $Panel/VBoxContainer/VBoxContainer/HBoxContainer3/SFXLabel
@onready var click_sound = $"../ClickSound"

# Idioma
@onready var language_option = $Panel/VBoxContainer/VBoxContainer/HBoxContainer4/LanguageOptionsButton
const LANGUAGE_CODES := ["en", "es", "ca"]

# Botones
@onready var back_button = $Panel/VBoxContainer/VBoxContainer/VBoxContainer2/Back
@onready var quit_button = $Panel/VBoxContainer/VBoxContainer/VBoxContainer2/Quit

# Señal para notificar que la configuración se cerró
@export var from_pause: bool = false   # 👈 Saber de dónde fue abierto
signal settings_closed(reopen_pause: bool)

func _ready():
	if OS.has_feature("web"):
		quit_button.visible = false

	# Conectar sliders
	volume_slider.value_changed.connect(_on_volume_changed)
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)

	# Conectar selección de idioma
	language_option.item_selected.connect(_on_language_selected)

	# Conectar botones
	back_button.pressed.connect(_on_back_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	#Inicio de sliders desde globals
	volume_slider.value = Globals.master_volume
	music_slider.value = Globals.music_volume
	sfx_slider.value = Globals.sfx_volume

	volume_label.text = "%d%%" % int(round(Globals.master_volume * 100))
	music_label.text = "%d%%" % int(round(Globals.music_volume * 100))
	sfx_label.text = "%d%%" % int(round(Globals.sfx_volume * 100))
	
	#Inicializar idioma desde globals
	var idx = Globals.LANGUAGE_CODES.find(Globals.language)
	if idx != -1:
		language_option.select(idx)
	else:
		language_option.select(0)
# ==========================
#   AUDIO
# ==========================
func _on_volume_changed(value):
	volume_label.text = "%d%%" % int(round(value * 100))
	Globals.master_volume = value
	Globals.apply_all_volumes()
	Globals.save_settings()

func _on_music_volume_changed(value):
	music_label.text = "%d%%" % int(round(value * 100))
	Globals.music_volume = value
	Globals.apply_all_volumes()
	Globals.save_settings()

func _on_sfx_volume_changed(value):
	sfx_label.text = "%d%%" % int(round(value * 100))
	Globals.sfx_volume = value
	Globals.apply_all_volumes()
	Globals.save_settings()

# ==========================
#   BOTONES
# ==========================
func _on_back_pressed():
	click_sound.play()
	if from_pause:
		settings_closed.emit(true)
	else:
		settings_closed.emit(false)
	queue_free()

func _on_quit_pressed():
	click_sound.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()

# ==========================
#   IDIOMA
# ==========================
func _on_language_selected(index: int) -> void:
	click_sound.play()
	click_sound.play()
	Globals.language = Globals.LANGUAGE_CODES[index]  # 🔥 guardamos en GLOBALS
	Globals.apply_language()
	Globals.save_settings()
