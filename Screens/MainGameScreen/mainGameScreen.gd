extends Screen

@export var fightScreen : Screen
@export var shopScreen : Screen
@export var playerCombatBoard : Board
@export var playerShopBoard : Board
@export var enemyBoard : Board

@export var act1Room1 : Screen
@export var act1Room2 : Screen
@export var act1Room3 : Screen

var act1Rooms = [null, act1Room1, act1Room2, act1Room3]

var currentRoom : Screen

var actNum : int
var roomNum : int

func _ready():
	_initalizeVariables()

func _initalizeVariables():
	actNum = 1
	roomNum = 1
	currentRoom = act1Room1

func _moveToNextRoom():
	if roomNum == 10:
		actNum += 1
		roomNum = 1
	else:
		roomNum += 1
		currentRoom = act1Rooms[roomNum]

func _on_battle_button_pressed():
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

func _setupBoards():
	enemyBoard._instantiateBoard()
	enemyBoard.show()
	playerCombatBoard._instantiateBoard()
	playerCombatBoard.show()

