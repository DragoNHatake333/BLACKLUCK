extends Node

@onready var revolverShot = $revolverShot
@onready var noBullet = $noBullet
@onready var revolverSpin = $revolverSpin

func call_sound_manager(sound: String):
	var sound_node = get_node(sound)
	if sound_node and sound_node is AudioStreamPlayer or AudioStreamPlayer2D:
		sound_node.play()
	else:
		print("Invalid sound:", sound)
