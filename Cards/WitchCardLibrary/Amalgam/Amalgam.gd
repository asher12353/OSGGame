extends Card
class_name Amalgam

static var CARD_TYPE = 2000

func _init():
	attack = 0
	health = 0
	cardArtPath = "res://Cards/witchCardLibrary/Amalgam/Amalgam.png"
	fullArtPath = "res://Cards/WitchCardLibrary/Amalgam/AmalgamFull.png"
	nameString = "Amalgam"
	textString = ""
	_Card()
