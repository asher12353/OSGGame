extends Character
class_name Witch

var playerShopBoard : Board
var playerHand : Board

var cauldron : Area2D
var cauldronPos = Vector2(800, 400)
var cardsInCauldron = []
var cardInCauldronArea : Card
var cauldronIsSpellcrafting : bool
var cauldronIsStitching : bool
var cauldronIsCursing : bool

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
	rect.size = Vector2(150, 210)
	collisionShape.shape = rect
	var art = Sprite2D.new()
	cauldron.add_child(art)
	var cardArtTexture = load("res://Characters/Witch/black cauldron.jpg")
	art.texture = cardArtTexture
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
		reagent._whenSpellIsCrafted(spell)
		reagent.hide()
	cardsInCauldron.clear()
	cauldronIsSpellcrafting = false

func _createAmalgam():
	var newCard
	var hasArm = false
	var hasLeg = false
	for card in cardsInCauldron:
		if card is AnArm:
			hasArm = true
		elif card is ALeg:
			hasLeg = true
	if hasArm and hasLeg:
		newCard = playerHand.createCard(AnArmAndALeg.new())
		newCard._giveStats(5, 4)
	else:
		newCard = playerHand.createCard(Amalgam.new())
	for card in cardsInCauldron:
		newCard._giveStats(card.attack, card.health)
	_removeCardsFromCauldron()
	cauldronIsStitching = false

func _createCurse():
	var curse = playerHand.createCard(Curse.new())
	for card in cardsInCauldron:
		curse.offerings.append(card)
	for offering in curse.offerings:
		offering._whenSpellIsCrafted(curse)
		offering.hide()
	cardsInCauldron.clear()
	cauldronIsSpellcrafting = false

func _removeCardsFromCauldron():
	for card in cardsInCauldron:
		print(card)
		card.free()
	cardsInCauldron.clear()
