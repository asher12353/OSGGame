extends Card
class_name MiffedMonke

static var numLeftInPool : int = 20
static var CARD_TYPE = 4001

func _init():
	attack = 2
	health = 2
	cardArtPath = "res://Cards/MonkeCardLibrary/MiffedMonke/MiffedMonke.png"
	fullArtPath = "res://Cards/MonkeCardLibrary/MiffedMonke/MiffedMonkeFull.png"
	nameString = "Miffed Monke"
	textString = "When it Attacks: gain +1/+1"
	whenItAttacksSynergy = 1
	synergies[whenItAttacksSynergyIndex] = whenItAttacksSynergy
	_Card()

func _WhenItAttacks():
	_givePlus1Plus1()
