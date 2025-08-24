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
		click_sound.play()
		play_button.hide()
		settings_button.hide()
		title_label.hide() 
		settings_button_sprite.hide()
		# Instancia la escena de configuración y añádela al árbol
		current_settings_menu_instance = settings_menu_scene.instantiate()
		current_settings_menu_instance.from_pause = false
		add_child(current_settings_menu_instance)

		# Conectar la señal settings_closed para saber cuándo se cierra
		current_settings_menu_instance.settings_closed.connect(_on_settings_menu_closed)





# Función para cuando el menú de configuración se cierra
func _on_settings_menu_closed(_reopen_pause: bool):
	current_settings_menu_instance = null # Limpiar la referencia
	# Mostrar los elementos del menú principal de nuevo
	play_button.show()
	settings_button.show()
	title_label.show() # Muestra el título de nuevo
	settings_button_sprite.show() #Muestra el sprite del boton de config
