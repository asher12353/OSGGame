extends Card
class_name AnArmAndALeg

static var CARD_TYPE = 2003

func _init():
	nameString = "An Arm and a Leg"
	textString = ""
	_giveStats(2, 2)
	cardArtPath = "res://Cards/witchCardLibrary/SpecialStitches/AnArmAndALeg/AnArmAndALeg.png"
	fullArtPath = "res://Cards/WitchCardLibrary/SpecialStitches/AnArmAndALeg/AnArmAndALegFull.png"
	undeadSynergy = 1
	synergies[undeadSynergyIndex] = undeadSynergy
	_Card()
