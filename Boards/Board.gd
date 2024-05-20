extends Node2D

class_name Board

var boardY : int
static var widthBetweenCards = Card.cardWidth + 25

static var xValuesForCards = [
	[0],
	[-widthBetweenCards / 2, widthBetweenCards / 2],
	[-widthBetweenCards, 0, widthBetweenCards],
	[-widthBetweenCards * 3/2, -widthBetweenCards / 2, widthBetweenCards / 2, widthBetweenCards * 3/2],
	[-widthBetweenCards * 2, -widthBetweenCards, 0, widthBetweenCards, widthBetweenCards * 2],
	[-widthBetweenCards * 5/2, -widthBetweenCards * 3/2, -widthBetweenCards / 2, widthBetweenCards / 2, widthBetweenCards * 3/2, widthBetweenCards * 5/2],
	[-widthBetweenCards * 3, -widthBetweenCards * 2, -widthBetweenCards, 0, widthBetweenCards, widthBetweenCards * 2, widthBetweenCards * 3]
]

func createCard(card : Card) -> Card:
	var ignoreMax = isCardToken(card)
	if get_child_count() == 7 and not ignoreMax:
		return
	var newCard = card.duplicate()
	newCard._changeBoard(self)
	_copyValues(card, newCard)
	_relocateCards(true)
	newCard.add_to_group("Persist")
	return newCard

func _relocateCards(teleportCards=false):
	var cards = get_children()
	var numCards = cards.size()
	_relocateMultipleCards(numCards, teleportCards)
	if name != "npcShopBoard":
		%masterLogicHandler._relocateCardDropZones()

func _relocateMultipleCards(numCards, teleportCards):
	var cards = get_children()
	numCards -= 1 # this is just due to indexing
	for card in cards:
		if numCards < 7:
			if teleportCards:
				card.position = Vector2(xValuesForCards[numCards][card.get_index()], boardY)
			else:
				card.targetLocation = Vector2(xValuesForCards[numCards][card.get_index()], boardY)
		
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

func _copyValues(card : Card, newCard : Card):
	newCard._copyStats(card)
	if card.imbuedCurses:
		_copyImbuedCurses(card, newCard)
	if card is Curse:
		_copyOfferings(card, newCard)

func _copyImbuedCurses(card : Card, newCard : Card):
	newCard.imbuedCurses = Node2D.new()
	for curse in card.imbuedCurses.get_children():
		var newCurse = createCard(curse)
		if newCurse: #maybe delete this
			newCurse.reparent(newCard.imbuedCurses)

func _copyOfferings(card : Card, newCard : Card):
	newCard.offerings = card.offerings
	newCard.isTargeted = card.isTargeted
	newCard._Spell()
	newCard._updateSpellText()
