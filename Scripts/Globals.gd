extends Node


var revolver_chambers := []
var current_chamber := 0

func spin_revolver():
	revolver_chambers = [false, false, false, false, false, false]
	var bullet_index = randi() % 6
	revolver_chambers[bullet_index] = true
	current_chamber = 0
	print("Revolver loaded. Bullet is in chamber", bullet_index + 1)
var _mouse_inside := false
var playerPickedCard := false
var croupierTurn = false
var playerTurn = false
var aiTurn = false
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
var centerHand = {
	1: {"placement": 1, "card": ""},
	2: {"placement": 2, "card": ""}, 
	3: {"placement": 3, "card": ""},
}
var centerCards = 0
var centerGive = 0
var newcardGive = []
var cardDict = {
	"Ace_of_Clubs": {"value": 1, "image_path": "res://Cards/ace_of_clubs.png"},
	"2_of_Clubs": {"value": 2, "image_path": "res://Cards/2_of_clubs.png"},
	"3_of_Clubs": {"value": 3, "image_path": "res://Cards/3_of_clubs.png"},
	"4_of_Clubs": {"value": 4, "image_path": "res://Cards/4_of_clubs.png"},
	"5_of_Clubs": {"value": 5, "image_path": "res://Cards/5_of_clubs.png"},
	"6_of_Clubs": {"value": 6, "image_path": "res://Cards/6_of_clubs.png"},
	"7_of_Clubs": {"value": 7, "image_path": "res://Cards/7_of_clubs.png"},
	"8_of_Clubs": {"value": 8, "image_path": "res://Cards/8_of_clubs.png"},
	"9_of_Clubs": {"value": 9, "image_path": "res://Cards/9_of_clubs.png"},
	"10_of_Clubs": {"value": 10, "image_path": "res://Cards/10_of_clubs.png"},
	"Jack_of_Clubs": {"value": 11, "image_path": "res://Cards/jack_of_clubs.png"},
	"Queen_of_Clubs": {"value": 12, "image_path": "res://Cards/queen_of_clubs.png"},
	"King_of_Clubs": {"value": 13, "image_path": "res://Cards/king_of_clubs.png"},

	"Ace_of_Diamonds": {"value": 1, "image_path": "res://Cards/ace_of_diamonds.png"},
	"2_of_Diamonds": {"value": 2, "image_path": "res://Cards/2_of_diamonds.png"},
	"3_of_Diamonds": {"value": 3, "image_path": "res://Cards/3_of_diamonds.png"},
	"4_of_Diamonds": {"value": 4, "image_path": "res://Cards/4_of_diamonds.png"},
	"5_of_Diamonds": {"value": 5, "image_path": "res://Cards/5_of_diamonds.png"},
	"6_of_Diamonds": {"value": 6, "image_path": "res://Cards/6_of_diamonds.png"},
	"7_of_Diamonds": {"value": 7, "image_path": "res://Cards/7_of_diamonds.png"},
	"8_of_Diamonds": {"value": 8, "image_path": "res://Cards/8_of_diamonds.png"},
	"9_of_Diamonds": {"value": 9, "image_path": "res://Cards/9_of_diamonds.png"},
	"10_of_Diamonds": {"value": 10, "image_path": "res://Cards/10_of_diamonds.png"},
	"Jack_of_Diamonds": {"value": 11, "image_path": "res://Cards/jack_of_diamonds.png"},
	"Queen_of_Diamonds": {"value": 12, "image_path": "res://Cards/queen_of_diamonds.png"},
	"King_of_Diamonds": {"value": 13, "image_path": "res://Cards/king_of_diamonds.png"},

	"Ace_of_Hearts": {"value": 1, "image_path": "res://Cards/ace_of_hearts.png"},
	"2_of_Hearts": {"value": 2, "image_path": "res://Cards/2_of_hearts.png"},
	"3_of_Hearts": {"value": 3, "image_path": "res://Cards/3_of_hearts.png"},
	"4_of_Hearts": {"value": 4, "image_path": "res://Cards/4_of_hearts.png"},
	"5_of_Hearts": {"value": 5, "image_path": "res://Cards/5_of_hearts.png"},
	"6_of_Hearts": {"value": 6, "image_path": "res://Cards/6_of_hearts.png"},
	"7_of_Hearts": {"value": 7, "image_path": "res://Cards/7_of_hearts.png"},
	"8_of_Hearts": {"value": 8, "image_path": "res://Cards/8_of_hearts.png"},
	"9_of_Hearts": {"value": 9, "image_path": "res://Cards/9_of_hearts.png"},
	"10_of_Hearts": {"value": 10, "image_path": "res://Cards/10_of_hearts.png"},
	"Jack_of_Hearts": {"value": 11, "image_path": "res://Cards/jack_of_hearts.png"},
	"Queen_of_Hearts": {"value": 12, "image_path": "res://Cards/queen_of_hearts.png"},
	"King_of_Hearts": {"value": 13, "image_path": "res://Cards/king_of_hearts.png"},

	"Ace_of_Spades": {"value": 1, "image_path": "res://Cards/ace_of_spades.png"},
	"2_of_Spades": {"value": 2, "image_path": "res://Cards/2_of_spades.png"},
	"3_of_Spades": {"value": 3, "image_path": "res://Cards/3_of_spades.png"},
	"4_of_Spades": {"value": 4, "image_path": "res://Cards/4_of_spades.png"},
	"5_of_Spades": {"value": 5, "image_path": "res://Cards/5_of_spades.png"},
	"6_of_Spades": {"value": 6, "image_path": "res://Cards/6_of_spades.png"},
	"7_of_Spades": {"value": 7, "image_path": "res://Cards/7_of_spades.png"},
	"8_of_Spades": {"value": 8, "image_path": "res://Cards/8_of_spades.png"},
	"9_of_Spades": {"value": 9, "image_path": "res://Cards/9_of_spades.png"},
	"10_of_Spades": {"value": 10, "image_path": "res://Cards/10_of_spades.png"},
	"Jack_of_Spades": {"value": 11, "image_path": "res://Cards/jack_of_spades.png"},
	"Queen_of_Spades": {"value": 12, "image_path": "res://Cards/queen_of_spades.png"},
	"King_of_Spades": {"value": 13, "image_path": "res://Cards/king_of_spades.png"}
}
var fullDeck = {
	"Ace_of_Clubs": {"value": 1, "image_path": "res://Cards/ace_of_clubs.png"},
	"2_of_Clubs": {"value": 2, "image_path": "res://Cards/2_of_clubs.png"},
	"3_of_Clubs": {"value": 3, "image_path": "res://Cards/3_of_clubs.png"},
	"4_of_Clubs": {"value": 4, "image_path": "res://Cards/4_of_clubs.png"},
	"5_of_Clubs": {"value": 5, "image_path": "res://Cards/5_of_clubs.png"},
	"6_of_Clubs": {"value": 6, "image_path": "res://Cards/6_of_clubs.png"},
	"7_of_Clubs": {"value": 7, "image_path": "res://Cards/7_of_clubs.png"},
	"8_of_Clubs": {"value": 8, "image_path": "res://Cards/8_of_clubs.png"},
	"9_of_Clubs": {"value": 9, "image_path": "res://Cards/9_of_clubs.png"},
	"10_of_Clubs": {"value": 10, "image_path": "res://Cards/10_of_clubs.png"},
	"Jack_of_Clubs": {"value": 11, "image_path": "res://Cards/jack_of_clubs.png"},
	"Queen_of_Clubs": {"value": 12, "image_path": "res://Cards/queen_of_clubs.png"},
	"King_of_Clubs": {"value": 13, "image_path": "res://Cards/king_of_clubs.png"},

	"Ace_of_Diamonds": {"value": 1, "image_path": "res://Cards/ace_of_diamonds.png"},
	"2_of_Diamonds": {"value": 2, "image_path": "res://Cards/2_of_diamonds.png"},
	"3_of_Diamonds": {"value": 3, "image_path": "res://Cards/3_of_diamonds.png"},
	"4_of_Diamonds": {"value": 4, "image_path": "res://Cards/4_of_diamonds.png"},
	"5_of_Diamonds": {"value": 5, "image_path": "res://Cards/5_of_diamonds.png"},
	"6_of_Diamonds": {"value": 6, "image_path": "res://Cards/6_of_diamonds.png"},
	"7_of_Diamonds": {"value": 7, "image_path": "res://Cards/7_of_diamonds.png"},
	"8_of_Diamonds": {"value": 8, "image_path": "res://Cards/8_of_diamonds.png"},
	"9_of_Diamonds": {"value": 9, "image_path": "res://Cards/9_of_diamonds.png"},
	"10_of_Diamonds": {"value": 10, "image_path": "res://Cards/10_of_diamonds.png"},
	"Jack_of_Diamonds": {"value": 11, "image_path": "res://Cards/jack_of_diamonds.png"},
	"Queen_of_Diamonds": {"value": 12, "image_path": "res://Cards/queen_of_diamonds.png"},
	"King_of_Diamonds": {"value": 13, "image_path": "res://Cards/king_of_diamonds.png"},

	"Ace_of_Hearts": {"value": 1, "image_path": "res://Cards/ace_of_hearts.png"},
	"2_of_Hearts": {"value": 2, "image_path": "res://Cards/2_of_hearts.png"},
	"3_of_Hearts": {"value": 3, "image_path": "res://Cards/3_of_hearts.png"},
	"4_of_Hearts": {"value": 4, "image_path": "res://Cards/4_of_hearts.png"},
	"5_of_Hearts": {"value": 5, "image_path": "res://Cards/5_of_hearts.png"},
	"6_of_Hearts": {"value": 6, "image_path": "res://Cards/6_of_hearts.png"},
	"7_of_Hearts": {"value": 7, "image_path": "res://Cards/7_of_hearts.png"},
	"8_of_Hearts": {"value": 8, "image_path": "res://Cards/8_of_hearts.png"},
	"9_of_Hearts": {"value": 9, "image_path": "res://Cards/9_of_hearts.png"},
	"10_of_Hearts": {"value": 10, "image_path": "res://Cards/10_of_hearts.png"},
	"Jack_of_Hearts": {"value": 11, "image_path": "res://Cards/jack_of_hearts.png"},
	"Queen_of_Hearts": {"value": 12, "image_path": "res://Cards/queen_of_hearts.png"},
	"King_of_Hearts": {"value": 13, "image_path": "res://Cards/king_of_hearts.png"},

	"Ace_of_Spades": {"value": 1, "image_path": "res://Cards/ace_of_spades.png"},
	"2_of_Spades": {"value": 2, "image_path": "res://Cards/2_of_spades.png"},
	"3_of_Spades": {"value": 3, "image_path": "res://Cards/3_of_spades.png"},
	"4_of_Spades": {"value": 4, "image_path": "res://Cards/4_of_spades.png"},
	"5_of_Spades": {"value": 5, "image_path": "res://Cards/5_of_spades.png"},
	"6_of_Spades": {"value": 6, "image_path": "res://Cards/6_of_spades.png"},
	"7_of_Spades": {"value": 7, "image_path": "res://Cards/7_of_spades.png"},
	"8_of_Spades": {"value": 8, "image_path": "res://Cards/8_of_spades.png"},
	"9_of_Spades": {"value": 9, "image_path": "res://Cards/9_of_spades.png"},
	"10_of_Spades": {"value": 10, "image_path": "res://Cards/10_of_spades.png"},
	"Jack_of_Spades": {"value": 11, "image_path": "res://Cards/jack_of_spades.png"},
	"Queen_of_Spades": {"value": 12, "image_path": "res://Cards/queen_of_spades.png"},
	"King_of_Spades": {"value": 13, "image_path": "res://Cards/king_of_spades.png"}
}
var shuffledDeck = {}
var positions_dict = {}
