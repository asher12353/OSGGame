extends Card
class_name HungryMonke

static var numLeftInPool : int = 20
static var CARD_TYPE = 4002

func _init():
	attack = 2
	health = 2
	cardArtPath = "res://Cards/MonkeCardLibrary/HungryMonke/HungryMonke.png"
	fullArtPath = "res://Cards/MonkeCardLibrary/HungryMonke/HungryMonkeFull.png"
	nameString = "Hungry Monke"
	textString = "When this eats a banana, \ngain +1/+1"
	bananaSynergy = 1
	synergies[bananaSynergyIndex] = bananaSynergy
	_Card()

func _WhenBananaIsPlayedOnSelf():
	_givePlus1Plus1()
