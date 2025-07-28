extends Node

var is_animating
var STOPHOVER = false
var releaseCardMenu 
var canvasModulate = true
var revolver_chambers := []
var current_chamber := 0
var is_card_hover = false
var revolverSpin
var deckTurn = false
var playerTurn = false
var aiTurn = false
var cards_in_center_hand = 0
var playerRevolverPressed = false
var isCardDragging = false
var firstRevolver = false

func spin_revolver():
	revolver_chambers = [false, false, false, false, false, false]
	if firstRevolver == false:
		firstRevolver = true
	else:
		emit_signal("callSoundManager", "revolverSpin")
	var real_bullet = randi() % 6
	#randi() % 6
	revolver_chambers[real_bullet] = true
	current_chamber = 0
	print("Globals: Revolver loaded: bullet is in chamber ", real_bullet + 1, ".")


var playerShootHimself = false
var aiShootHimself = false
var saveRound = false
var centerDeck = [
	"ace_of_clubs", "2_of_clubs", "3_of_clubs", "4_of_clubs", "5_of_clubs", "6_of_clubs", "7_of_clubs", "8_of_clubs", "9_of_clubs", "10_of_clubs",
	"jack_of_clubs", "queen_of_clubs", "king_of_clubs",

	"ace_of_diamonds", "2_of_diamonds", "3_of_diamonds", "4_of_diamonds", "5_of_diamonds", "6_of_diamonds", "7_of_diamonds", "8_of_diamonds", "9_of_diamonds", "10_of_diamonds",
	"jack_of_diamonds", "queen_of_diamonds", "king_of_diamonds",

	"ace_of_hearts", "2_of_hearts", "3_of_hearts", "4_of_hearts", "5_of_hearts", "6_of_hearts", "7_of_hearts", "8_of_hearts", "9_of_hearts", "10_of_hearts",
	"jack_of_hearts", "queen_of_hearts", "king_of_hearts",

	"ace_of_spades", "2_of_spades", "3_of_spades", "4_of_spades", "5_of_spades", "6_of_spades", "7_of_spades", "8_of_spades", "9_of_spades", "10_of_spades",
	"jack_of_spades", "queen_of_spades", "king_of_spades"
]
var fullCenterDeck = [
	"ace_of_clubs", "2_of_clubs", "3_of_clubs", "4_of_clubs", "5_of_clubs", "6_of_clubs", "7_of_clubs", "8_of_clubs", "9_of_clubs", "10_of_clubs",
	"jack_of_clubs", "queen_of_clubs", "king_of_clubs",

	"ace_of_diamonds", "2_of_diamonds", "3_of_diamonds", "4_of_diamonds", "5_of_diamonds", "6_of_diamonds", "7_of_diamonds", "8_of_diamonds", "9_of_diamonds", "10_of_diamonds",
	"jack_of_diamonds", "queen_of_diamonds", "king_of_diamonds",

	"ace_of_hearts", "2_of_hearts", "3_of_hearts", "4_of_hearts", "5_of_hearts", "6_of_hearts", "7_of_hearts", "8_of_hearts", "9_of_hearts", "10_of_hearts",
	"jack_of_hearts", "queen_of_hearts", "king_of_hearts",

	"ace_of_spades", "2_of_spades", "3_of_spades", "4_of_spades", "5_of_spades", "6_of_spades", "7_of_spades", "8_of_spades", "9_of_spades", "10_of_spades",
	"jack_of_spades", "queen_of_spades", "king_of_spades"
]
var playerPickedCard := false
var pressed_revolver = false
var playerSum = 0
var aiSum = 0
var playerAmount = 0
var aiAmount = 0
var playerHP = 3
var aiHP = 3
var playerHand = []
var aiHand = []
var aiFinished = false
var cardPos = {}
var centerHand = []
var centerCards = 0
var centerGive = 0
var newcardGive = []


var deck = {
	"ace_of_clubs": [1, "res://Cards/ace_of_clubs.png"],
	"2_of_clubs": [2, "res://Cards/2_of_clubs.png"],
	"3_of_clubs": [3, "res://Cards/3_of_clubs.png"],
	"4_of_clubs": [4, "res://Cards/4_of_clubs.png"],
	"5_of_clubs": [5, "res://Cards/5_of_clubs.png"],
	"6_of_clubs": [6, "res://Cards/6_of_clubs.png"],
	"7_of_clubs": [7, "res://Cards/7_of_clubs.png"],
	"8_of_clubs": [8, "res://Cards/8_of_clubs.png"],
	"9_of_clubs": [9, "res://Cards/9_of_clubs.png"],
	"10_of_clubs": [10, "res://Cards/10_of_clubs.png"],
	"jack_of_clubs": [11, "res://Cards/jack_of_clubs.png"],
	"queen_of_clubs": [12, "res://Cards/queen_of_clubs.png"],
	"king_of_clubs": [13, "res://Cards/king_of_clubs.png"],

	"ace_of_diamonds": [1, "res://Cards/ace_of_diamonds.png"],
	"2_of_diamonds": [2, "res://Cards/2_of_diamonds.png"],
	"3_of_diamonds": [3, "res://Cards/3_of_diamonds.png"],
	"4_of_diamonds": [4, "res://Cards/4_of_diamonds.png"],
	"5_of_diamonds": [5, "res://Cards/5_of_diamonds.png"],
	"6_of_diamonds": [6, "res://Cards/6_of_diamonds.png"],
	"7_of_diamonds": [7, "res://Cards/7_of_diamonds.png"],
	"8_of_diamonds": [8, "res://Cards/8_of_diamonds.png"],
	"9_of_diamonds": [9, "res://Cards/9_of_diamonds.png"],
	"10_of_diamonds": [10, "res://Cards/10_of_diamonds.png"],
	"jack_of_diamonds": [11, "res://Cards/jack_of_diamonds.png"],
	"queen_of_diamonds": [12, "res://Cards/queen_of_diamonds.png"],
	"king_of_diamonds": [13, "res://Cards/king_of_diamonds.png"],

	"ace_of_hearts": [1, "res://Cards/ace_of_hearts.png"],
	"2_of_hearts": [2, "res://Cards/2_of_hearts.png"],
	"3_of_hearts": [3, "res://Cards/3_of_hearts.png"],
	"4_of_hearts": [4, "res://Cards/4_of_hearts.png"],
	"5_of_hearts": [5, "res://Cards/5_of_hearts.png"],
	"6_of_hearts": [6, "res://Cards/6_of_hearts.png"],
	"7_of_hearts": [7, "res://Cards/7_of_hearts.png"],
	"8_of_hearts": [8, "res://Cards/8_of_hearts.png"],
	"9_of_hearts": [9, "res://Cards/9_of_hearts.png"],
	"10_of_hearts": [10, "res://Cards/10_of_hearts.png"],
	"jack_of_hearts": [11, "res://Cards/jack_of_hearts.png"],
	"queen_of_hearts": [12, "res://Cards/queen_of_hearts.png"],
	"king_of_hearts": [13, "res://Cards/king_of_hearts.png"],

	"ace_of_spades": [1, "res://Cards/ace_of_spades.png"],
	"2_of_spades": [2, "res://Cards/2_of_spades.png"],
	"3_of_spades": [3, "res://Cards/3_of_spades.png"],
	"4_of_spades": [4, "res://Cards/4_of_spades.png"],
	"5_of_spades": [5, "res://Cards/5_of_spades.png"],
	"6_of_spades": [6, "res://Cards/6_of_spades.png"],
	"7_of_spades": [7, "res://Cards/7_of_spades.png"],
	"8_of_spades": [8, "res://Cards/8_of_spades.png"],
	"9_of_spades": [9, "res://Cards/9_of_spades.png"],
	"10_of_spades": [10, "res://Cards/10_of_spades.png"],
	"jack_of_spades": [11, "res://Cards/jack_of_spades.png"],
	"queen_of_spades": [12, "res://Cards/queen_of_spades.png"],
	"king_of_spades": [13, "res://Cards/king_of_spades.png"]
}

const FULLDECK = {
	"ace_of_clubs": [1, "res://Cards/ace_of_clubs.png"],
	"2_of_clubs": [2, "res://Cards/2_of_clubs.png"],
	"3_of_clubs": [3, "res://Cards/3_of_clubs.png"],
	"4_of_clubs": [4, "res://Cards/4_of_clubs.png"],
	"5_of_clubs": [5, "res://Cards/5_of_clubs.png"],
	"6_of_clubs": [6, "res://Cards/6_of_clubs.png"],
	"7_of_clubs": [7, "res://Cards/7_of_clubs.png"],
	"8_of_clubs": [8, "res://Cards/8_of_clubs.png"],
	"9_of_clubs": [9, "res://Cards/9_of_clubs.png"],
	"10_of_clubs": [10, "res://Cards/10_of_clubs.png"],
	"jack_of_clubs": [11, "res://Cards/jack_of_clubs.png"],
	"queen_of_clubs": [12, "res://Cards/queen_of_clubs.png"],
	"king_of_clubs": [13, "res://Cards/king_of_clubs.png"],

	"ace_of_diamonds": [1, "res://Cards/ace_of_diamonds.png"],
	"2_of_diamonds": [2, "res://Cards/2_of_diamonds.png"],
	"3_of_diamonds": [3, "res://Cards/3_of_diamonds.png"],
	"4_of_diamonds": [4, "res://Cards/4_of_diamonds.png"],
	"5_of_diamonds": [5, "res://Cards/5_of_diamonds.png"],
	"6_of_diamonds": [6, "res://Cards/6_of_diamonds.png"],
	"7_of_diamonds": [7, "res://Cards/7_of_diamonds.png"],
	"8_of_diamonds": [8, "res://Cards/8_of_diamonds.png"],
	"9_of_diamonds": [9, "res://Cards/9_of_diamonds.png"],
	"10_of_diamonds": [10, "res://Cards/10_of_diamonds.png"],
	"jack_of_diamonds": [11, "res://Cards/jack_of_diamonds.png"],
	"queen_of_diamonds": [12, "res://Cards/queen_of_diamonds.png"],
	"king_of_diamonds": [13, "res://Cards/king_of_diamonds.png"],

	"ace_of_hearts": [1, "res://Cards/ace_of_hearts.png"],
	"2_of_hearts": [2, "res://Cards/2_of_hearts.png"],
	"3_of_hearts": [3, "res://Cards/3_of_hearts.png"],
	"4_of_hearts": [4, "res://Cards/4_of_hearts.png"],
	"5_of_hearts": [5, "res://Cards/5_of_hearts.png"],
	"6_of_hearts": [6, "res://Cards/6_of_hearts.png"],
	"7_of_hearts": [7, "res://Cards/7_of_hearts.png"],
	"8_of_hearts": [8, "res://Cards/8_of_hearts.png"],
	"9_of_hearts": [9, "res://Cards/9_of_hearts.png"],
	"10_of_hearts": [10, "res://Cards/10_of_hearts.png"],
	"jack_of_hearts": [11, "res://Cards/jack_of_hearts.png"],
	"queen_of_hearts": [12, "res://Cards/queen_of_hearts.png"],
	"king_of_hearts": [13, "res://Cards/king_of_hearts.png"],

	"ace_of_spades": [1, "res://Cards/ace_of_spades.png"],
	"2_of_spades": [2, "res://Cards/2_of_spades.png"],
	"3_of_spades": [3, "res://Cards/3_of_spades.png"],
	"4_of_spades": [4, "res://Cards/4_of_spades.png"],
	"5_of_spades": [5, "res://Cards/5_of_spades.png"],
	"6_of_spades": [6, "res://Cards/6_of_spades.png"],
	"7_of_spades": [7, "res://Cards/7_of_spades.png"],
	"8_of_spades": [8, "res://Cards/8_of_spades.png"],
	"9_of_spades": [9, "res://Cards/9_of_spades.png"],
	"10_of_spades": [10, "res://Cards/10_of_spades.png"],
	"jack_of_spades": [11, "res://Cards/jack_of_spades.png"],
	"queen_of_spades": [12, "res://Cards/queen_of_spades.png"],
	"king_of_spades": [13, "res://Cards/king_of_spades.png"]
}

var positions_dict = {}
