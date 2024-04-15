extends Card
class_name Skeleton

static var CARD_TYPE = 3000

func _init():
	attack = 1
	health = 1
	cardArtPath = "res://Cards/Tokens/Skeleton/Skeleton.png"
	fullArtPath = "res://Cards/Tokens/Skeleton/SkeletonFull.png"
	nameString = "Skeleton"
	textString = ""
	_Card()
