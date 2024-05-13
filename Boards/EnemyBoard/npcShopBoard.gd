extends Board

const numCardsInPoolPerLevel = [20, 15, 12, 10, 8, 7]
var totalNumCardsInPool = 0

var numCardsInShop = 3

func _ready():
	boardY = -120
	for card in %masterLogicHandler.neutralCardLibrary:
		totalNumCardsInPool += card.numLeftInPool

func _updatePool():
	if MasterLogicHandler.mainCharacter is Witch:
		for card in MasterLogicHandler.witchCardLibrary:
			totalNumCardsInPool += card.numLeftInPool

func _refreshBoard():
	for child in get_children():
		child.numLeftInPool += 1
		totalNumCardsInPool += 1
		child.free()
	for i in range(numCardsInShop):
		createCardFromPool()
	for card in get_children():
		card.position = Vector2(xValuesForCards[numCardsInShop - 1][numCardsInShop - 1], boardY)
		card.targetLocation = Vector2(xValuesForCards[numCardsInShop - 1][card.get_index()], boardY)
		card.speed = 12.0

func createCardFromPool(): #-> Card:
	var threshhold = 0
	var randomNumber = MasterLogicHandler.rng.randi_range(0, totalNumCardsInPool - 1)
	for card in MasterLogicHandler.neutralCardLibrary:
		if randomNumber >= threshhold and randomNumber < threshhold + card.numLeftInPool:
			card.numLeftInPool -= 1
			totalNumCardsInPool -= 1
			return createCard(card)
		else:
			threshhold += card.numLeftInPool
	if MasterLogicHandler.mainCharacter is Witch:
		for card in MasterLogicHandler.witchCardLibrary:
			if randomNumber >= threshhold and randomNumber < threshhold + card.numLeftInPool:
				card.numLeftInPool -= 1
				totalNumCardsInPool -= 1
				return createCard(card)
			else:
				threshhold += card.numLeftInPool
