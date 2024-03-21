extends Board

const numCardsInPoolPerLevel = [20, 15, 12, 10, 8, 7]
var totalNumCardsInPool = 0

var numCardsInShop = 3

func _ready():
	boardY = -120
	for card in %masterLogicHandler.differentKindsOfCards:
		totalNumCardsInPool += card.numLeftInPool

func _refreshBoard():
	for child in get_children():
		child.numLeftInPool += 1
		totalNumCardsInPool += 1
		child.free()
	for i in range(numCardsInShop):
		_createCardFromPool()
	
func _createCardFromPool():
	var threshhold = 0
	var randomNumber = %masterLogicHandler.rng.randi_range(0, totalNumCardsInPool - 1)
	for card in %masterLogicHandler.differentKindsOfCards:
		if randomNumber >= threshhold and randomNumber < threshhold + card.numLeftInPool:
			_createCard(card)
			card.numLeftInPool -= 1
			totalNumCardsInPool -= 1
			break
		else:
			threshhold += card.numLeftInPool
