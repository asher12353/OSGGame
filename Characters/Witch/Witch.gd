extends Character
class_name Witch

var playerShopBoard : Board
var playerHand : Board

var cauldron : Area2D
var cauldronPos = Vector2(850, 400)
var cardsInCauldron = []
var cardInCauldronArea : Card
var cauldronIsSpellcrafting : bool
var cauldronIsStitching : bool
var cauldronIsCursing : bool

var spellPower : int = 0
var cursePower : int = 0

var cardArtSize = Vector2(768, 1024)
var cardScale = Vector2(0.25, 0.25)

func _process(_delta):
	if cardCanBeAddedToCauldron():
		_addCardToCauldron()
		if cardsInCauldron.size() == 2:
			if cauldronIsSpellcrafting:
				_createSpell()
			elif cauldronIsStitching:
				_createAmalgam()
			elif cauldronIsCursing:
				_createCurse()

func _init():
	_initializeCauldron()
	playerShopBoard = MasterLogicHandler.playerShopBoard
	playerHand = MasterLogicHandler.playerHand

func _initializeCauldron():
	cauldron = Area2D.new()
	MasterLogicHandler.shopScreen.add_child(cauldron)
	cauldron.global_position = cauldronPos
	var collisionShape = CollisionShape2D.new()
	cauldron.add_child(collisionShape)
	var rect = RectangleShape2D.new()
	rect.size = cardArtSize * cardScale
	collisionShape.shape = rect
	var art = Sprite2D.new()
	cauldron.add_child(art)
	var cardArtTexture = load("res://Characters/Witch/blackCauldron.png")
	art.texture = cardArtTexture
	art.scale = cardScale
	cauldron.area_entered.connect(Callable(self, "_card_entered_cauldron_area"))
	cauldron.area_exited.connect(Callable(self, "_card_exited_cauldron_area"))
	cauldronIsSpellcrafting = false
	cauldronIsStitching = false
	cauldronIsCursing = false

func cardCanBeAddedToCauldron() -> bool:
	if cardsInCauldron.size() == 0:
		return cardInCauldronArea and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and cardInCauldronArea.board == MasterLogicHandler.playerShopBoard and (cardInCauldronArea.isReagent or cardInCauldronArea.isCadaver or cardInCauldronArea.isOffering)
	else:
		if cauldronIsSpellcrafting:
			return playerIsPlacingCard() and cardInCauldronArea.isReagent
		elif cauldronIsStitching:
			return playerIsPlacingCard() and cardInCauldronArea.isCadaver
		elif cauldronIsCursing:
			return playerIsPlacingCard() and cardInCauldronArea.isOffering
	return false
	
func playerIsPlacingCard() -> bool:
	return cardInCauldronArea and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and cardInCauldronArea.board == MasterLogicHandler.playerShopBoard

func _addCardToCauldron():
	if cardsInCauldron.size() == 0:
		if cardInCauldronArea.isReagent:
			cauldronIsSpellcrafting = true
		elif cardInCauldronArea.isCadaver:
			cauldronIsStitching = true
		elif cardInCauldronArea.isOffering:
			cauldronIsCursing = true
	cardsInCauldron.append(cardInCauldronArea)
	_stopDraggingCard()

func _stopDraggingCard():
	cardInCauldronArea.board = null
	cardInCauldronArea.reparent(cauldron)
	cardInCauldronArea.is_dragging = false
	cardInCauldronArea.is_draggable = false
	cardInCauldronArea.is_draggable_at_all = false
	cardInCauldronArea.set_global_position(cauldronPos)
	Card.dragged_card = null
	playerShopBoard._relocateCards()

func _card_entered_cauldron_area(area):
	if area is Card:
		cardInCauldronArea = area

func _card_exited_cauldron_area(_area):
	cardInCauldronArea = null

func _createSpell():
	var spell = playerHand.createCard(BrewedSpell.new())
	for card in cardsInCauldron:
		spell.reagents.append(card)
	for reagent in spell.reagents:
		reagent.numLeftInPool += 1
		reagent._whenSpellIsCrafted(spell)
		reagent.hide()
		spell.textString = spell.textString + "\n" + reagent.spellText 
	spell._Spell()
	cardsInCauldron.clear()
	cauldronIsSpellcrafting = false

func _createAmalgam():
	var newCard
	var hasArm = false
	var hasLeg = false
	for card in cardsInCauldron:
		card.numLeftInPool += 1
		if card is AnArm:
			hasArm = true
		elif card is ALeg:
			hasLeg = true
	if hasArm and hasLeg:
		newCard = playerHand.createCard(AnArmAndALeg.new())
	else:
		newCard = playerHand.createCard(Amalgam.new())
	for card in cardsInCauldron:
		newCard._giveStats(card.attack, card.health)
	_removeCardsFromCauldron()
	cauldronIsStitching = false

func _createCurse():
	var curse = playerHand.createCard(Curse.new())
	for card in cardsInCauldron:
		card.numLeftInPool += 1
		curse.offerings.append(card)
	for offering in curse.offerings:
		offering._whenSpellIsCrafted(curse)
		offering.hide()
		curse.textString = curse.textString + "\n" + offering.spellText
	curse._Spell()
	cardsInCauldron.clear()
	cauldronIsSpellcrafting = false

func _removeCardsFromCauldron():
	for card in cardsInCauldron:
		card.free()
	cardsInCauldron.clear()

signal curse_power_changed
