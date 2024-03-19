extends Screen

@export var fightScreen : Screen
@export var shopScreen : Screen
@export var playerCombatBoard : Board
@export var playerShopBoard : Board
@export var enemyBoard : Board

@export var act1Room1 : Screen
@export var act1Room2 : Screen

var currentRoom : Screen

var actNum : int
var roomNum : int

func _ready():
	_initalizeVariables()

func _initalizeVariables():
	actNum = 1
	roomNum = 1
	currentRoom = act1Room1

func _on_battle_button_pressed():
	%masterLogicHandler._changeScreen(fightScreen)
	%masterLogicHandler.cardsAreMovable = true
	%masterLogicHandler.currentShownBoard = playerCombatBoard
	_setupBoards()

func _on_shop_button_pressed():
	%masterLogicHandler._changeScreen(shopScreen)
	%masterLogicHandler.currentShownBoard = playerShopBoard
	currentRoom = act1Room2 # replace later with a way to get the next room
	shopScreen._initialize()

func _setupBoards():
	enemyBoard._instantiateBoard()
	enemyBoard.show()
	playerCombatBoard._instantiateBoard()
	playerCombatBoard.show()

