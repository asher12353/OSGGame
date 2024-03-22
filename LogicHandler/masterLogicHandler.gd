extends Node2D
class_name LogicHandler

var currentPos : int
var currentShownBoard : Board
var currentCardInADropZone : Card
var currentCardInADropZoneIndex : int

static var playerShopBoard : Board
static var playerHand: Board
static var globalUIElements : Node2D
static var mainGameScreen : Screen
static var startScreen : Screen

static var currentScreen : Screen
static var mainCharacter : Character

static var cardsAreMovable : bool

static var differentKindsOfCards = [Frg.new(), OctoBro.new()]

static var uniqueCards = [Spawn.new()]

static var artifactPool = [SpyGlass.new()]

var rng = RandomNumberGenerator.new()

const xValuesForCardDropZones = [
	[0],
	[-100, 100],
	[-200, 0,    200],
	[-300, -100, 100,  300],
	[-400, -200, 0,    200,  400],
	[-500, -300, -100, 100,  300, 500],
	[-600, -400, -200, 0,    200, 400, 600],
	[-700, -500, -300, -100, 100, 300, 500, 700]
	]

func _ready():
	currentScreen = startScreen
	playerShopBoard = get_node("/root/main/playerShopBoard")
	playerHand = get_node("/root/main/playerHand")
	globalUIElements = get_node("/root/main/globalUIElements")
	mainGameScreen = get_node("/root/main/mainGameScreen")
	startScreen = get_node("/root/main/startScreen")
	
func _process(_delta):
	if cardCanBeRelocated() and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_relocateCardToCurrentPosition()
	if cardCanBePlaced():
		_playCard()
		
func cardCanBeRelocated() -> bool:
	return currentPos != 0 and currentCardInADropZone and currentCardInADropZone.get_parent() == currentShownBoard

func _relocateCardToCurrentPosition():
	if cardIsToTheRight():
		currentShownBoard.move_child(currentCardInADropZone, currentPos - 1)
	elif cardIsToTheLeft():
		currentShownBoard.move_child(currentCardInADropZone, currentPos - 2)
	currentPos = 0
	
func cardIsToTheLeft() -> bool:
	return currentPos - 1 > currentCardInADropZoneIndex
	
func cardIsToTheRight() -> bool:
	return currentPos - 1 < currentCardInADropZoneIndex
	
func cardCanBePlaced() -> bool:
	return currentPos != 0 and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and currentCardInADropZone and currentCardInADropZone.get_parent() == playerHand and currentShownBoard.get_child_count() < 7

func _playCard():
	currentCardInADropZone.board = playerShopBoard
	currentCardInADropZone.reparent(playerShopBoard)
	currentShownBoard.move_child(currentCardInADropZone, currentPos - 1)
	currentCardInADropZone._WhenPlayed()
	currentPos = 0

func _changeScreen(screen):
	if currentScreen == mainGameScreen.currentRoom:
		mainGameScreen.hide()
	currentScreen.hide()
	if screen == mainGameScreen:
		screen.show()
		currentScreen = mainGameScreen.currentRoom
	else:
		currentScreen = screen
	currentScreen.show()

func _setMainCharacter(character):
	mainCharacter = character


func _updateMoney(difference):
	mainCharacter.money += difference
	globalUIElements._updateMoneyLabel(mainCharacter.money)

func _relocateCardDropZones():
	if currentShownBoard == playerShopBoard:
		var numCards = playerShopBoard.get_child_count()
		var children = get_child(0).get_children()
		for i in range(0, numCards + 1):
			children[i].monitoring = true
			children[i].show()
			children[i].set_position(Vector2(xValuesForCardDropZones[numCards][i], playerShopBoard.boardY))
		for i in range(numCards + 1, 8):
			children[i].monitoring = false
			children[i].hide()

func _updateCurrentCardPosition():
	if not currentShownBoard:
		return
	for i in range(currentShownBoard.get_child_count()):
		if currentShownBoard.get_child(i) == currentCardInADropZone:
			currentCardInADropZoneIndex = i
			break
		else:
			i += 1
	
func _cardDropZoneEntered(card, pos):
	currentPos = pos
	if card is Card:
		currentCardInADropZone = card
	_updateCurrentCardPosition()
	
func _cardDropZoneExited():
	currentPos = 0
	currentCardInADropZone = null
	
# consider looking at alternatives for ALLL of these functions
func _on_pos_1_area_entered(area):
	_cardDropZoneEntered(area, 1)

func _on_pos_1_area_exited(_area):
	_cardDropZoneExited()

func _on_pos_2_area_entered(area):
	_cardDropZoneEntered(area, 2)

func _on_pos_2_area_exited(_area):
	_cardDropZoneExited()


func _on_pos_3_area_entered(area):
	_cardDropZoneEntered(area, 3)


func _on_pos_3_area_exited(_area):
	_cardDropZoneExited()


func _on_pos_4_area_entered(area):
	_cardDropZoneEntered(area, 4)


func _on_pos_4_area_exited(_area):
	_cardDropZoneExited()


func _on_pos_5_area_entered(area):
	_cardDropZoneEntered(area, 5)


func _on_pos_5_area_exited(_area):
	_cardDropZoneExited()


func _on_pos_6_area_entered(area):
	_cardDropZoneEntered(area, 6)

func _on_pos_6_area_exited(_area):
	_cardDropZoneExited()


func _on_pos_7_area_entered(area):
	_cardDropZoneEntered(area, 7)


func _on_pos_7_area_exited(_area):
	_cardDropZoneExited()


func _on_pos_8_area_entered(area):
	_cardDropZoneEntered(area, 8)


func _on_pos_8_area_exited(_area):
	_cardDropZoneExited()
