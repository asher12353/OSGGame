extends Card
class_name Amalgam

static var CARD_TYPE = 2000

func _init():
	nameString = "Amalgam"
	textString = ""
	attack = 0
	health = 0
	cardArtPath = "res://Cards/witchCardLibrary/Amalgam/Amalgam.png"
	fullArtPath = "res://Cards/WitchCardLibrary/Amalgam/AmalgamFull.png"
	undeadSynergy = 1
	synergies[undeadSynergyIndex] = undeadSynergy
	_Card()
