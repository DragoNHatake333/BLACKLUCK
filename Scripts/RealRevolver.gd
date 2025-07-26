extends Area2D

signal drawCards
var tweenFinished = true
signal callSoundManager(sound)
signal callAnimationManager

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and Globals.playerTurn == true:
		if Globals.playerRevolverPressed == false:
			if Globals.playerTurn == true:
				Globals.playerRevolverPressed = true
				if Globals.revolver_chambers[Globals.current_chamber]:
					emit_signal("callAnimationManager", "revolver", "player", "bullet")
					await get_tree().create_timer(12.0).timeout
					Globals.spin_revolver()
					emit_signal("callSoundManager","revolverSpin")
					Globals.cards_in_center_hand = 0
					for child in $"../CardManager".get_children():
						if child.name not in Globals.playerHand and child.name not in Globals.aiHand:
							remove_child(child)
							child.queue_free()
					Globals.centerHand = []
					Globals.playerShootHimself = true
					Globals.playerAmount = 5
					Globals.aiSum = 1
					Globals.playerSum = 0
					Globals.aiAmount = 5
					Globals.saveRound = true
					Globals.playerTurn = false
				else:
					emit_signal("callAnimationManager", "revolver", "player", "noBullet")
					await get_tree().create_timer(12).timeout
					Globals.cards_in_center_hand = 0
					for child in $"../CardManager".get_children():
						if child.name not in Globals.playerHand and child.name not in Globals.aiHand:
							$"../CardManager".remove_child(child)
							child.queue_free()
					Globals.centerHand = []
					Globals.current_chamber += 1
					emit_signal("drawCards")
			else:
				return

@onready var target_node = $"../3DViewport/SubViewportContainer/SubViewport/Sketchfab_Scene"
var base_position_y = 0.0
var actual_position_y = 0.0
var is_hovered := false

func _ready():
	base_position_y = target_node.position.y

func _on_mouse_entered() -> void:
	if Globals.STOPHOVER == false:
		if not target_node.position.y == 1.0 and Globals.isCardDragging == false and Globals.playerTurn == true and Globals.playerRevolverPressed == false:
			var tween = create_tween()
			tween.tween_property(target_node, "position:y", base_position_y + 1.0, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			emit_signal("callSoundManager", "revolverHovered")
func _on_mouse_exited() -> void:
	if Globals.STOPHOVER == false:
		var tween = create_tween()
		tween.tween_property(target_node, "position:y", base_position_y, 0.4).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
