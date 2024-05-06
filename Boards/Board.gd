extends Node2D

class_name Board

var boardY : int
var newCard

const xValuesForCards = [
	[0],
	[-100, 100],
	[-200, 0, 200],
	[-300, -100, 100, 300],
	[-400, -200, 0, 200, 400],
	[-500, -300, -100, 100, 300, 500],
	[-600, -400, -200, 0, 200, 400, 600]
]

func createCard(card : Card) -> Card:
	var ignoreMax = isCardToken(card)
	if get_child_count() == 7 and not ignoreMax:
		return
	newCard = card.duplicate()
	_copyValues(card)
	add_child(newCard)
	_relocateCards()
	return newCard

func _relocateCards():
	var cards = get_children()
	var numCards = cards.size()
	_relocateMultipleCards(numCards)
	if name != "npcShopBoard":
		%masterLogicHandler._relocateCardDropZones()

func _relocateMultipleCards(numCards):
	var cards = get_children()
	numCards -= 1 # this is just due to indexing
	for card in cards:
		if numCards < 7:
			card.set_position(Vector2(xValuesForCards[numCards][card.get_index()], boardY))
		
func getTotalSpellPower() -> int:
	var spellpower = 0
	for card in get_children():
		spellpower += card.spellPower
	return spellpower
	
func getTotalCursePower() -> int:
	var cursepower = 0
	for card in get_children():
		cursepower += card.cursePower
	return cursepower

func getRandomCard() -> Card:
	return get_child(randi_range(0, get_child_count() - 1))

func containsAProtectCard() -> bool:
	for card in get_children():
		if card.hasProtect:
			return true
	return false
	
func isCardToken(card) -> bool:
	for token in MasterLogicHandler.tokenCardLibrary:
			if "CARD_TYPE" in card and token.CARD_TYPE == card.CARD_TYPE:
				return true
	return false

func _copyValues(card : Card):
	newCard._copyStats(card)
	newCard.board = self
	if card.imbuedCurses:
		_copyImbuedCurses(card)
	if card is Curse:
		_copyOfferings(card)

func _copyImbuedCurses(card : Card):
	newCard.imbuedCurses = Node2D.new()
	for curse in card.imbuedCurses.get_children():
		var newCurse = createCard(curse)
		if newCurse: #maybe delete this
			newCurse.reparent(newCard.imbuedCurses)

func _copyOfferings(card : Card):
	newCard.offerings = card.offerings
	newCard.isTargeted = card.isTargeted
	newCard._Spell()
	newCard._updateSpellText()
