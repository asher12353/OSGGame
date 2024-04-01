extends Card
class_name Frg

static var numLeftInPool : int = 20
static var CARD_TYPE = 1

func _init():
	attack = 2
	health = 1
	cardArtPath = "res://Cards/NeutralCardLibrary/Frg/FrgColored.png"
	fullArtPath = "res://Cards/NeutralCardLibrary/Frg/FrgColoredFull.png"
	_Card()
	

func _WhenPlayed():
	if board.name == "playerShopBoard": 
		MasterLogicHandler._updateMoney(1)
