extends Card
class_name MysteryCard

static var CARD_TYPE = 0

# Called when the node enters the scene tree for the first time.
func _init():
	attack = 0
	health = 0
	cardArtPath = "res://Cards/MysteryCard/MysteryCard.png"
	fullArtPath = "res://Cards/MysteryCard/MysteryCardFull.png"
	nameString = "???"
	textString = "???"
	hasFullArt = false
	_Card()
	attackLabel.hide()
	healthLabel.hide()
	cardBack.hide()
