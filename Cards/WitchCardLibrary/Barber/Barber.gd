extends Card
class_name Barber

static var numLeftInPool : int = 20
static var CARD_TYPE = 2005

func _init():
	attack = 1
	health = 3
	cardArtPath = "res://Cards/WitchCardLibrary/Barber/Barber.png"
	fullArtPath = "res://Cards/WitchCardLibrary/Barber/BarberFull.png"
	nameString = "Evil Barber"
	textString = "When Played: Add a\n 0/1 hair to your hand"
	_Card()

func _WhenPlayed():
	MasterLogicHandler.playerHand.createCard(Hair.new())
