# MainMenu.gd
extends Control

@onready var play_button = $PlayButton
@onready var settings_button = $OptionsButton
@onready var title_label = $PlayButton # Asumo que es el mismo nodo PlayButton el que muestra el título
@onready var settings_button_sprite = $Cylinder
@onready var click_sound = $ClickSound

var settings_menu_scene = preload("res://Scenes/settings_menu.tscn") # Carga previa de la escena de configuración
var current_settings_menu_instance = null # Para guardar la instancia del menú de configuración

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Conectar botones
	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)

	# Si tenías un _on_back_pressed en MainMenu que era para salir del juego, ese sería el quit_button.
	# Si era para otra cosa, asegúrate de que esté conectado correctamente o elimínalo si ya no es necesario.
	# Aquí el quit_button asume el rol de "Salir del Juego"

# ==========================
#   BOTONES
# ==========================
func _on_play_pressed():
	click_sound.play()
	await get_tree().create_timer(0.2).timeout
	SceneManager.change_scene("res://Scenes/loading_screen.tscn")


func _on_settings_pressed():
	if current_settings_menu_instance == null:
		click_sound.play()
		# Ocultar elementos del menú principal si es necesario
		play_button.hide()
		settings_button.hide()
		title_label.hide() # Oculta el título si está en el mismo nodo PlayButton.
		settings_button_sprite.hide() #Oculta el sprite del boton de config
		# Instancia la escena de configuración y añádela al árbol
		current_settings_menu_instance = settings_menu_scene.instantiate()
		add_child(current_settings_menu_instance)

		# Centrar el menú de configuración
		current_settings_menu_instance.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
		current_settings_menu_instance.set_position(
			current_settings_menu_instance.get_position() - current_settings_menu_instance.get_size() / 2
		)

		# Conectar la señal settings_closed para saber cuándo se cierra
		current_settings_menu_instance.settings_closed.connect(_on_settings_menu_closed)
	else:
		# Si ya está abierto, puedes ignorar el clic o volver a ocultarlo si lo prefieres
		print("Settings menu already open.")





# Función para cuando el menú de configuración se cierra
func _on_settings_menu_closed():
	current_settings_menu_instance = null # Limpiar la referencia
	# Mostrar los elementos del menú principal de nuevo
	play_button.show()
	settings_button.show()
	title_label.show() # Muestra el título de nuevo
	settings_button_sprite.show() #Muestra el sprite del boton de config
