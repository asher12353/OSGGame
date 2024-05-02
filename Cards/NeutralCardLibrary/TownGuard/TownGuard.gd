extends Card
class_name TownGuard

static var numLeftInPool : int = 20
static var CARD_TYPE = 3

func _init():
	nameString = "Town Guard"
	textString = "Protect"
	attack = 2
	health = 3
	hasProtect = true
	cardArtPath = "res://Cards/NeutralCardLibrary/TownGuard/TownGuard.png"
	fullArtPath = "res://Cards/NeutralCardLibrary/TownGuard/TownGuardFull.png"
	protectSynergy = 1
	synergies[protectSynergyIndex] = protectSynergy
	_Card()
