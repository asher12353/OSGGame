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

var xValuesForCardDropZones = Board.xValuesForCards.duplicate()
var dropZonesTotalWidth = Board.widthBetweenCards * 8

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
	xValuesForCardDropZones.append([-Board.widthBetweenCards * 7/2, -Board.widthBetweenCards * 5/2, -Board.widthBetweenCards * 3/2, -Board.widthBetweenCards / 2, Board.widthBetweenCards / 2, Board.widthBetweenCards * 3/2, Board.widthBetweenCards * 5/2, Board.widthBetweenCards * 7/2])

func _changeScreen(screen):
	#if screen == fightScreen:
		#masterMusicPlayer._changeMusic(masterMusicPlayer.BATTLE)
	#elif screen == shopScreen:
		#masterMusicPlayer._changeMusic(masterMusicPlayer.SHOP)
	if currentScreen.is_in_group("Persist"):
		currentScreen.remove_from_group("Persist")
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
	currentScreen.add_to_group("Persist")
	_saveGame()

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

func _saveGame():
	var saveFile = FileAccess.open("user://save.save", FileAccess.WRITE)
	var saveNodes = get_tree().get_nodes_in_group("Persist")
	for node in saveNodes:
		if node is Card and node.board == playerShopBoard or node is Screen:
			var nodeData = node.call("save")
			var jsonString = JSON.stringify(nodeData)
			saveFile.store_line(jsonString)

func _loadGame():
	var saveNodes = get_tree().get_nodes_in_group("Persist")
	for i in saveNodes:
		i.queue_free()
	var saveFile = FileAccess.open("user://save.save", FileAccess.READ)
	while saveFile.get_position() < saveFile.get_length():
		var jsonString = saveFile.get_line()
		var json = JSON.new()
		var parseResult = json.parse(jsonString)
		if parseResult != OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", jsonString, " at line ", json.get_error_line())
			continue
		var nodeData = json.get_data()
		var nodeName = nodeData.get("name")
		if nodeName == null:
			continue
		for screen in get_parent().get_children():
			if screen.name == nodeName:
				_changeScreen(screen)
		for screen in mainGameScreen.get_children():
			if screen.name == nodeName:
				_changeScreen(screen)

func _clearSave():
	if FileAccess.file_exists("user://save.save"):
		var file = FileAccess.open("user://save.save", FileAccess.WRITE)
		file.close()
