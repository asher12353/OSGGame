extends Card
class_name ALeg

static var numLeftInPool : int = 20
static var CARD_TYPE = 2002

func _init():
	attack = 2
	health = 4
	isCadaver = true
	cardArtPath = "res://Cards/witchCardLibrary/ALeg/ALeg.png"
	fullArtPath = "res://Cards/WitchCardLibrary/ALeg/ALegFull.png"
	_Card()
	
