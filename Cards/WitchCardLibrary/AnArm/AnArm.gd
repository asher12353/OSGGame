extends Card
class_name AnArm

static var numLeftInPool : int = 20
static var CARD_TYPE = 2001

func _init():
	attack = 3
	health = 2
	isCadaver = true
	cardArtPath = "res://Cards/witchCardLibrary/AnArm/AnArm.png"
	fullArtPath = "res://Cards/WitchCardLibrary/AnArm/AnArmFull.png"
	nameString = "An Arm"
	textString = "Cadaver"
	undeadSynergy = 1
	synergies[undeadSynergyIndex] = undeadSynergy
	_Card()
	
