extends Control

func _ready() -> void:
	hide()

func resume():
	hide()
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")

func pause():
	show()
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()

func _on_resume_pressed():
	resume()

func _on_quit_pressed():
	get_tree().paused = false
	SceneManager.change_scene("res://ui/MainMenu/Scenes/MainMenu.tscn")
	
func _process(_delta):
	testEsc()

func _on_main_menu_pressed() -> void:
	_on_quit_pressed()
