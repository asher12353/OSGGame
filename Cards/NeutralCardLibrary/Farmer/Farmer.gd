extends Card
class_name Farmer

static var numLeftInPool : int = 20
static var CARD_TYPE = 4

func _init():
	attack = 1
	health = 1
	cardArtPath = "res://Cards/NeutralCardLibrary/Farmer/Farmer.png"
	fullArtPath = "res://Cards/NeutralCardLibrary/Farmer/FarmerFull.png"
	nameString = "Farmer"
	textString = "When it dies: Create a 1/1 \nskeleton"
	tokenSynergy = 1
	whenItDiesSynergy = 1
	_Card()

func _WhenItDies():
	var card = board.createCard(Skeleton.new())
	board.move_child(card, get_index())
