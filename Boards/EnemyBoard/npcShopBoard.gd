extends Board

const numCardsInPoolPerLevel = [20, 15, 12, 10, 8, 7]
var differentKindsOfCards = [Frg.new(), OctoBro.new()]
var totalNumCardsInPool = 0

var numCardsInShop = 3

func _ready():
	boardY = -120
	for card in differentKindsOfCards:
		totalNumCardsInPool += card.numLeftInPool


# insert fancy refresh algorithm here later
func _refreshBoard():
	for child in get_children():
		child.numLeftInPool += 1
		remove_child(child)
	for i in range(numCardsInShop):
		var threshhold = 0
		var randomNumber = %masterLogicHandler.rng.randi_range(0, totalNumCardsInPool)
		for card in differentKindsOfCards:
			if randomNumber >= threshhold and randomNumber < threshhold + card.numLeftInPool:
				_createCard(card)
				card.numLeftInPool -= 1
				totalNumCardsInPool -= 1
				break
			else:
				threshhold += card.numLeftInPool
