extends Node2D

class_name Board

var boardY : int

const xValuesForCards = [
	[0],
	[-100, 100],
	[-200, 0, 200],
	[-300, -100, 100, 300],
	[-400, -200, 0, 200, 400],
	[-500, -300, -100, 100, 300, 500],
	[-600, -400, -200, 0, 200, 400, 600]
]

func createCard(card) -> Card:
	if get_child_count() == 7:
		return
	var newCard = card.duplicate()
	add_child(newCard)
	newCard._copyStats(card)
	newCard.board = self
	_relocateCards()
	return newCard

func _relocateCards():
	var cards = get_children()
	var numCards = cards.size()
	if(numCards == 0): return
	else: _relocateMultipleCards(numCards)
	if not name == "npcShopBoard":
		%masterLogicHandler._relocateCardDropZones()

func _relocateMultipleCards(numCards):
	var cards = get_children()
	numCards -= 1 # this is just due to indexing
	for card in cards:
		card.set_position(Vector2(xValuesForCards[numCards][card.get_index()], boardY))

func getRandomCard() -> Card:
	return get_child(randi_range(0, get_child_count() - 1))
