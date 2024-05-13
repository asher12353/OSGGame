extends Card
class_name Farmer

static var numLeftInPool : int = 20
static var CARD_TYPE = 4

func _init():
	nameString = "Farmer"
	textString = "When it dies: Create a 1/1 \nskeleton"
	attack = 1
	health = 1
	cardArtPath = "res://Cards/NeutralCardLibrary/Farmer/Farmer.png"
	fullArtPath = "res://Cards/NeutralCardLibrary/Farmer/FarmerFull.png"
	attackAnimation = load("res://Cards/attackAnimations/slash/slash.tres")
	tokenSynergy = 1
	synergies[tokenSynergyIndex] = tokenSynergy
	whenItDiesSynergy = 1
	synergies[whenItDiesSynergyIndex] = whenItDiesSynergy
	_Card()

func _WhenItDies():
	var card = board.createCard(Skeleton.new())
	board.move_child(card, get_index())
