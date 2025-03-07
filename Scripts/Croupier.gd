extends Node

var centerHand = {
	1: {"placement": 6, "card": ""},
	2: {"placement": 7, "card": ""}, 
	3: {"placement": 8, "card": ""},
	4: {"placement": 9, "card": ""},
	5: {"placement": 10, "card": ""}
}
	
var centerCards = 0
var centerGive = 0
var newcardGive = []

var shuffledDeck = Globals.cardDict.keys()
var cardValue = "card"

func randomizeDict():
	print("Croupier: Randomizing keys!")
	shuffledDeck.shuffle()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Croupier: Croupier is on.")
	_on_game_manager_call_croupier()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_game_manager_call_croupier() -> void:
	print("Croupier: The croupier is here!")
	randomizeDict()
	centerGive = (centerCards - 5) * -1
	
	#Adding the amount of cards missing to the list newcardGive
	for i in range(centerGive):
		newcardGive.append(shuffledDeck[i])
	print(centerGive)
	
	#Adding the values to the dictionary
	var idx = 1
	for i in newcardGive:
		while idx <= centerGive + 1 and idx<= 5:
			if centerHand[idx]["card"] == "":
				centerHand[idx]["card"] = i
				idx += 1
				break
			else:
				idx += 1
				
	for key in centerHand:
		var card_name = centerHand[key]["card"]
		if card_name in Globals.cardDict:
			var sprite = Sprite2D.new()
			sprite.texture = load(Globals.cardDict[card_name]["image_path"])
			
			var adjust_key = key + 5
			
			if key in Globals.positions_dict:
				var position = Globals.positions_dict[adjust_key]
				sprite.position = Vector2(position["posx"], position["posy"])
			sprite.scale = Vector2(0.38, 0.38)
			add_child(sprite)
			
	Globals.croupierFinished = true
