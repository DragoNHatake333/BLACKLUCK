extends Node

signal callSoundManager
var firstRevolver = true

func spinRevolver():
	Globals.revolver_chambers = [false, false, false, false, false, false]
	var real_bullet = 0
	#randi() % 6
	Globals.revolver_chambers[real_bullet] = true
	Globals.current_chamber = 0
	print("Globals: Revolver loaded: bullet is in chamber ", real_bullet + 1, ".")
	if firstRevolver == true:
		firstRevolver = false
	elif Globals.silentRevolver == true:
		Globals.silentRevolver = false
	else:
		await get_tree().create_timer(0.5).timeout
		emit_signal("callSoundManager", "revolverSpin")
