extends Node2D

var progress = []
var sceneName
var scene_load = 0

func _ready() -> void:
	sceneName = "res://Scenes/Table.tscn"
	ResourceLoader.load_threaded_request(sceneName)
	
signal bullet_loaded(step: int)

var bullet_step = 0

func _process(_delta: float) -> void:
	scene_load = ResourceLoader.load_threaded_get_status(sceneName, progress)
	var pct = progress[0]  # 0.0 to 1.0

	var target_step = int(floor(pct * 6))  # 0 to 6
	if target_step > bullet_step:
		bullet_step = target_step
		emit_signal("bullet_loaded", bullet_step) # sends 1..6
	if scene_load == ResourceLoader.THREAD_LOAD_LOADED:
		var newScene = ResourceLoader.load_threaded_get(sceneName)
		SceneManager.change_scene("res://Scenes/Table.tscn")
