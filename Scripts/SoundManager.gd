extends Node

@onready var revolverShot = $revolverShot
@onready var noBullet = $noBullet
@onready var revolverSpin = $revolverSpin
@onready var candleOff = $candleOff
@onready var candleOffAI = $candleOffAI
var soundPlaying = true

func _ready() -> void:
	Globals.connect("callSoundManager", Callable(self, "call_sound_manager"))

func call_sound_manager(sound: String):
	if sound == "deckDeal":
		var random = randi_range(1, 3)
		match random:
			1:
				$deckDeal.stream = load("res://Assets/Sound/deckDeal.wav")
			2:
				$deckDeal.stream = load("res://Assets/Sound/deckDeal2.wav")
			3:
				$deckDeal.stream = load("res://Assets/Sound/deckDeal3.wav")

	var sound_node = get_node(sound)
	if sound_node and (sound_node is AudioStreamPlayer or sound_node is AudioStreamPlayer2D):
		sound_node.play()
	else:
		print("Invalid sound:", sound)
		
func play_random_sound():
	pass
	#Here it will play a random creepy sound every now and then.
