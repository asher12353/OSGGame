extends Card
class_name OctoBro

static var numLeftInPool : int = 20
static var CARD_TYPE = 2

func _init():
	attack = 1
	health = 1
	cardArtPath = "res://Cards/OctoBro/OctoBroColored.png"
	_Card()

func _WhenPlayed():
	_giveRandomCardPlus1Plus1()

func _giveRandomCardPlus1Plus1():
	var randomCard = getRandomCardOtherThanSelf()
	if randomCard:
		randomCard._givePlus1Plus1()
	
func getRandomCardOtherThanSelf() -> Card:
	if board.get_child_count() == 1:
		return
	var randomCard = board.get_child(MasterLogicHandler.rng.randi_range(0, board.get_child_count() - 1)) as Card
	while randomCard == self:
		randomCard = board.get_child(MasterLogicHandler.rng.randi_range(0, board.get_child_count() - 1)) as Card
	return randomCard
