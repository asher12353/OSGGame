extends Card
class_name CursedScroll

static var CARD_TYPE = 2008
static var numLeftInPool : int = 20

func _init():
	attack = 0
	health = 1
	cursePower = 1
	cardArtPath = "res://Cards/WitchCardLibrary/CursedScroll/CursedScroll.png"
	fullArtPath = "res://Cards/WitchCardLibrary/CursedScroll/CursedScrollFull.png"
	nameString = "Cursed Scroll"
	textString = "Curse Power +1"
	curseSynergy = 1
	synergies[curseSynergyIndex] = curseSynergy
	_Card()
