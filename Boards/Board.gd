extends Node2D

class_name Board

var boardY : int
static var numDifferentCards : int = 2 

const xValuesForCards = [
	[0],
	[-100, 100],
	[-200, 0, 200],
	[-300, -100, 100, 300],
	[-400, -200, 0, 200, 400],
	[-500, -300, -100, 100, 300, 500],
	[-600, -400, -200, 0, 200, 400, 600]
]

func _createCard(card):
	var newCard = card.duplicate()
	#for kindOfCard in %masterLogicHandler.uniqueCards:
		#if card.CARD_TYPE == kindOfCard.CARD_TYPE:
			#newCard = card.duplicate()
			#break
	#for kindOfCard in %masterLogicHandler.differentKindsOfCards:
		#if card.CARD_TYPE == MysteryCard.CARD_TYPE:
			#newCard = MysteryCard.new()
			#break
		#if card.CARD_TYPE == kindOfCard.CARD_TYPE:
			#newCard = card.duplicate()
			#break
	add_child(newCard)
	newCard.board = self
	_relocateCards()

func _relocateCards():
	var cards = get_children()
	var numCards = cards.size()
	if(numCards == 0): return
	elif(numCards == 1): _relocateOneCard()
	else: _relocateMultipleCards(numCards)
	if not name == "npcShopBoard":
		%masterLogicHandler._relocateCardDropZones()

func _relocateOneCard():
	var card = get_child(0)
	card.set_position(Vector2(xValuesForCards[0][0], boardY))

func _relocateMultipleCards(numCards):
	var cards = get_children()
	numCards -= 1 # this is just due to indexing
	for card in cards:
		card.set_position(Vector2(xValuesForCards[numCards][card.get_index()], boardY))
