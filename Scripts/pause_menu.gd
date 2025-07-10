extends Control

var transitioning := false

func _ready() -> void:
	hide()

func resume():
	if transitioning:
		return
	transitioning = true
	Globals.canvasModulate = true
	get_tree().paused = false
	await get_tree().create_timer(0.01).timeout
	$AnimationPlayer.play_backwards("blur")
	await get_tree().create_timer(0.3).timeout
	hide()
	transitioning = false

func pause():
	if transitioning:
		return
	transitioning = true
	show()
	Globals.canvasModulate = false
	await get_tree().create_timer(0.01).timeout
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	# Optional: Wait until blur finishes before allowing new input
	await get_tree().create_timer(0.3).timeout
	transitioning = false

func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		if Globals.isCardDragging == true:
			Globals.releaseCardMenu = true
		pause()
	if Input.is_action_just_pressed("esc") and get_tree().paused:
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
