extends Card
class_name VoodooDoll

static var CARD_TYPE = 2007
static var numLeftInPool : int = 20

func _init():
	nameString = "Voodoo Doll"
	textString = "Effigy 1"
	attack = 1
	health = 1
	isEffigy = true
	effigyValue = 1
	cardArtPath = "res://Cards/WitchCardLibrary/VoodooDoll/VoodooDoll.png"
	fullArtPath = "res://Cards/WitchCardLibrary/VoodooDoll/VoodooDollFull.png"
	curseSynergy = 1
	synergies[curseSynergyIndex] = curseSynergy
	_Card()
