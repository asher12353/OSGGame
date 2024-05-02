extends Card
class_name GymMonke

static var numLeftInPool : int = 20
static var CARD_TYPE = 4003

func _init():
	nameString = "Gym Monke"
	textString = ""
	attack = 4
	health = 4
	cardArtPath = "res://Cards/MonkeCardLibrary/GymMonke/GymMonke.png"
	fullArtPath = "res://Cards/MonkeCardLibrary/GymMonke/GymMonkeFull.png"
	hasNoSynergy = true
	_Card()
