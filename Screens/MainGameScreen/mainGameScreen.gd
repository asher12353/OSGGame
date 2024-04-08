extends Screen

@export var fightScreen : Screen
@export var shopScreen : Screen
@export var playerCombatBoard : Board
@export var playerShopBoard : Board
@export var enemyBoard : Board
@export var playerHand : Board

var act1Rooms
var currentRoom : Screen

var actNum : int
var roomNum : int

func _ready():
	_initalizeVariables()
	_moveToNextRoom()

func _initalizeVariables():
	actNum = 1
	roomNum = 0
	act1Rooms = get_children()

func _moveToNextRoom():
	if roomNum == 10:
		actNum += 1
		roomNum = 1
	else:
		roomNum += 1
		currentRoom = act1Rooms[roomNum - 1]

func _on_battle_button_pressed():
	fightScreen.isEliteFight = false
	_changeScreenToFightScreen()
	
func _on_elite_battle_button_pressed():
	fightScreen.isEliteFight = true
	_changeScreenToFightScreen()

func _changeScreenToFightScreen():
	%masterLogicHandler._changeScreen(fightScreen)
	%masterLogicHandler.cardsAreMovable = true
	%masterLogicHandler.currentShownBoard = playerCombatBoard
	_moveToNextRoom()
	_setupBoards()

func _on_shop_button_pressed():
	%masterLogicHandler._changeScreen(shopScreen)
	%masterLogicHandler.currentShownBoard = playerShopBoard
	_moveToNextRoom()
	shopScreen._initialize()
	
func _on_event_button_pressed():
	currentRoom._event()
	_changeScreenToNextRoom()
	
func _on_event_button1_pressed():
	currentRoom._event1()
	_changeScreenToNextRoom()
	
func _on_event_button2_pressed():
	currentRoom._event2()
	_changeScreenToNextRoom()
	
func _changeScreenToNextRoom():
	_moveToNextRoom()
	#insert here a small delay to the next room, either a button or timer
	%masterLogicHandler._changeScreen(self)

func _setupBoards():
	enemyBoard._instantiateBoard()
	enemyBoard.show()
	playerCombatBoard._instantiateBoard()
	playerCombatBoard.show()
	playerHand.show()

