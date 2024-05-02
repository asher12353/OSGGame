extends Card
class_name BlacksmithApprentice

static var numLeftInPool : int = 20
static var CARD_TYPE = 2

func _init():
	nameString = "Blacksmith's Apprentice"
	textString = "When Played: Give another \nrandom minion you control +1/+1"
	attack = 1
	health = 1
	cardArtPath = "res://Cards/NeutralCardLibrary/BlacksmithApprentice/BlacksmithApprenticeColored.png"
	fullArtPath = "res://Cards/NeutralCardLibrary/BlacksmithApprentice/BlacksmithApprenticeFull.png"
	whenPlayedSynergy = 1
	synergies[whenPlayedSynergyIndex] = whenPlayedSynergy
	_Card()

func _WhenPlayed():
	_giveRandomCardPlus1Plus1()
