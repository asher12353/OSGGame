extends Node2D
class_name LogicHandler

static var playerShopBoard : Board
static var playerHand: Board
static var playerCombatBoard : Board
static var enemyBoard : Board
static var currentShownBoard : Board

static var globalUIElements : Control
static var masterMusicPlayer : AudioStreamPlayer

static var fightScreen : Screen
static var mainGameScreen : Screen
static var startScreen : Screen
static var shopScreen : Screen

static var currentScreen : Screen
static var mainCharacter : Character
static var mainCharacterMaxHealth = 5

static var cardsAreMovable : bool
static var inCombat : bool

static var neutralCardLibrary = [Frg.new(), BlacksmithApprentice.new(), TownGuard.new(), Farmer.new()]
static var tokenCardLibrary = [Skeleton.new()]
static var uniqueCardLibrary = [Spawn.new()]
static var witchCardLibrary = [AnArm.new(), ALeg.new(), Newt.new(), Barber.new(), VoodooDoll.new(), CursedScroll.new()]
static var monkeCardLibrary = [MonkeWithBanana.new(), MiffedMonke.new(), HungryMonke.new(), GymMonke.new()]
static var dwarfCardLibrary = []

static var artifactPool = [SpyGlass.new()]

static var rng = RandomNumberGenerator.new()

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
const dropZonesTotalWidth = 1500

func _ready():
	currentScreen = startScreen
	playerShopBoard = get_node("/root/main/playerShopBoard")
	playerHand = get_node("/root/main/playerHand")
	playerCombatBoard = get_node("/root/main/playerCombatBoard")
	enemyBoard = get_node("/root/main/enemyBoard")
	globalUIElements = get_node("/root/main/globalUIElements")
	fightScreen = get_node("/root/main/fightScreen")
	mainGameScreen = get_node("/root/main/mainGameScreen")
	startScreen = get_node("/root/main/startScreen")
	shopScreen = get_node("/root/main/shopScreen")
	masterMusicPlayer = get_node("/root/main/masterMusicPlayer")

func _changeScreen(screen):
	#if screen == fightScreen:
		#masterMusicPlayer._changeMusic(masterMusicPlayer.BATTLE)
	#elif screen == shopScreen:
		#masterMusicPlayer._changeMusic(masterMusicPlayer.SHOP)
	if currentScreen == mainGameScreen.currentRoom:
		mainGameScreen.hide()
	currentScreen.hide()
	if screen == mainGameScreen:
		masterMusicPlayer._changeMusic(masterMusicPlayer.TITLE_SCREEN)
		screen.show()
		currentScreen = mainGameScreen.currentRoom
	else:
		currentScreen = screen
	currentScreen.show()

func _setMainCharacter(character):
	mainCharacter = character
	add_child(mainCharacter)
	shopScreen.npcShopBoard._updatePool()
	_initializeDropZones()

func _updateMoney(difference):
	mainCharacter.money += difference
	globalUIElements._updateMoneyLabel(mainCharacter.money)

func _relocateCardDropZones():
	if currentShownBoard == playerShopBoard:
		var numCards = playerShopBoard.get_child_count()
		var children = get_child(0).get_children()
		for i in range(0, numCards + 1):
			var child = children[i]
			var offset = 0
			if i == 0 or i == numCards:
				child._setShape((dropZonesTotalWidth) / (numCards + 1), child.baseHeight)
				if numCards == 0:
					offset = 0
				else:
					offset = 300 - (numCards * 50)
				if offset < 0:
					offset *= -1
				if i == 0:
					offset *= -1
				#print(offset)
			else:
				child._setShape(child.baseWidth, child.baseHeight)
			child.monitoring = true
			child.show()
			child.set_position(Vector2(xValuesForCardDropZones[numCards][i] + offset, playerShopBoard.boardY))
		for i in range(numCards + 1, 8):
			var child = children[i]
			child._setShape(child.width, child.height)
			child.monitoring = false
			child.hide()
			
func _initializeDropZones():
	currentShownBoard = playerShopBoard
	_relocateCardDropZones()
	currentShownBoard = null
