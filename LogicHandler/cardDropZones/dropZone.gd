extends Area2D
class_name dropZone

var baseWidth = 100
var baseHeight = 180
var width = baseWidth
var height = baseHeight

var pos : int

var currentCardInADropZone : Card
var currentCardInADropZoneIndex : int
static var currentPos : int

var playerHand : Board
var playerCombatBoard : Board
var playerShopBoard : Board

func _ready():
	playerHand = MasterLogicHandler.playerHand
	playerCombatBoard = MasterLogicHandler.playerCombatBoard
	playerShopBoard = MasterLogicHandler.playerShopBoard
	_parseNameForPos()
	_createCollisionShape()
	_setShape(width, height)

func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	if isMouseOver(mouse_pos):
		_cardDropZoneEntered(Card.dragged_card)
	else:
		_cardDropZoneExited()
	if cardCanBeRelocated() and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_relocateCardToCurrentPosition()
	if cardCanBePlaced():
		_playCard()

func _setShape(w : int, h : int):
	var collisionShape = get_child(0)
	width = w
	height = h
	collisionShape.shape.size = Vector2(w, h)

func cardCanBeRelocated() -> bool:
	return currentPos != 0 and currentCardInADropZone != null and currentCardInADropZone.get_parent() == MasterLogicHandler.currentShownBoard and not MasterLogicHandler.inCombat

func _relocateCardToCurrentPosition():
	if cardIsToTheRight():
		MasterLogicHandler.currentShownBoard.move_child(currentCardInADropZone, currentPos - 1)
	elif cardIsToTheLeft():
		MasterLogicHandler.currentShownBoard.move_child(currentCardInADropZone, currentPos - 2)
	currentPos = 0
	
func cardIsToTheLeft() -> bool:
	return currentPos - 1 > currentCardInADropZoneIndex

func cardIsToTheRight() -> bool:
	return currentPos - 1 < currentCardInADropZoneIndex

func cardCanBePlaced() -> bool:
	return currentPos != 0 and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and currentCardInADropZone != null and currentCardInADropZone.get_parent() == playerHand and MasterLogicHandler.currentShownBoard.get_child_count() < 7 and not currentCardInADropZone is Spell and not MasterLogicHandler.currentShownBoard == playerCombatBoard

func _playCard():
	currentCardInADropZone._changeBoard(playerShopBoard)
	MasterLogicHandler.currentShownBoard.move_child(currentCardInADropZone, currentPos - 1)
	currentCardInADropZone._WhenPlayed()
	currentPos = 0
	playerHand._relocateCards()
	if currentCardInADropZone.cursePower > 0:
		MasterLogicHandler.mainCharacter.emit_signal("curse_power_changed")

func _cardDropZoneEntered(card):
	currentPos = pos
	if not card == null and card is Card and monitoring:
		currentCardInADropZone = card
	_updateCurrentCardPosition()
	
func _cardDropZoneExited():
	currentPos = 0
	currentCardInADropZone = null
	
func _updateCurrentCardPosition():
	if not MasterLogicHandler.currentShownBoard:
		return
	for i in range(MasterLogicHandler.currentShownBoard.get_child_count()):
		if MasterLogicHandler.currentShownBoard.get_child(i) == currentCardInADropZone:
			currentCardInADropZoneIndex = i
			break
		else:
			i += 1

func _createCollisionShape():
	var collisionShape = CollisionShape2D.new()
	add_child(collisionShape)
	var rect = RectangleShape2D.new()
	rect.size = Vector2(width, height)
	collisionShape.shape = rect

func isMouseOver(mouse_pos) -> bool:
	@warning_ignore("integer_division")
	return mouse_pos.x > position.x - width/2 and mouse_pos.y > position.y - height/2 and mouse_pos.x < position.x + width/2 and mouse_pos.y < position.y + height/2 and monitoring

func _parseNameForPos():
	var number_string = name.lstrip("pos")  # Get the last character
	if number_string.is_valid_int():  # Check if it's a number
		pos = int(number_string)
