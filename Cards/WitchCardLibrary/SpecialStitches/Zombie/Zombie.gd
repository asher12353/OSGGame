extends Card
class_name Zombie

static var CARD_TYPE = 2003

func _init():
	nameString = "Zombie"
	textString = ""
	_giveStats(2, 2)
	cardArtPath = "res://Cards/witchCardLibrary/SpecialStitches/Zombie/Zombie.png"
	fullArtPath = "res://Cards/WitchCardLibrary/SpecialStitches/Zombie/ZombieFull.png"
	undeadSynergy = 1
	synergies[undeadSynergyIndex] = undeadSynergy
	_Card()
