extends Card
class_name OctoBro

static var numLeftInPool : int = 20
static var CARD_TYPE = 2

func _init():
	nameString = "Octo Bro"
	textString = "When Played: Give another \nrandom minion you control +1/+1"
	attack = 1
	health = 1
	cardArtPath = "res://Cards/NeutralCardLibrary/OctoBro/OctoBroColored.png"
	fullArtPath = "res://Cards/NeutralCardLibrary/OctoBro/OctoBroColoredFull.png"
	whenPlayedSynergy = 1
	synergies[whenPlayedSynergyIndex] = whenPlayedSynergy
	_Card()

func _WhenPlayed():
	_giveRandomCardPlus1Plus1()
