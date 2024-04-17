extends Board
class_name EnemyBoard

@export var fightScreen : Screen

var mainGameScreen : Screen
var totalNumCardsInPool
var rng

# these booleans are just set to how they'll be for the demo
# THIS PARALLELS TO Card.gd!!!
var whenPlayedSynergy = 0
var whenItDiesSynergy = 0
var protectSynergy = 0
var tokenSynergy = 0

var isWitchFight : bool = false

var spellSynergy = 0
var undeadSynergy = 0
var curseSynergy = 0

var isMonkeFight : bool = true

var bananaSynergy = 0
var attackSynergy = 0
var hitmanSynergy = 0

var isDwarfFight : bool = false

var forgeSynergy = 0
var investSynergy = 0
# synergy 3

var synergies = [
  whenPlayedSynergy,
  whenItDiesSynergy,
  protectSynergy,
  tokenSynergy,
  spellSynergy,
  undeadSynergy,
  curseSynergy,
  bananaSynergy,
  attackSynergy,
  hitmanSynergy,
  forgeSynergy,
  investSynergy
]
var gold : int

func _ready():
	boardY = -140
	mainGameScreen = %masterLogicHandler.mainGameScreen
	rng = MasterLogicHandler.rng

func _updatePool():
	totalNumCardsInPool = 0
	for card in MasterLogicHandler.neutralCardLibrary:
		totalNumCardsInPool += card.numLeftInPool
	if isWitchFight:
		for card in MasterLogicHandler.witchCardLibrary:
			totalNumCardsInPool += card.numLeftInPool
	if isMonkeFight:
		for card in MasterLogicHandler.monkeCardLibrary:
			totalNumCardsInPool += card.numLeftInPool
	if isDwarfFight:
		for card in MasterLogicHandler.dwarfCardLibrary:
			totalNumCardsInPool += card.numLeftInPool

# this is where the big fancy algorithm will be written later
func _instantiateBoard():
	print("alright, starting the enemies turn")
	var roomNum = mainGameScreen.roomNum
	gold = 2 + int(pow(roomNum, 1.7) - roomNum * 1.8)
	_createTheCards()
	_obscureCards()
	for card in get_children():
		card.is_draggable_at_all = false

func _createTheCards():
	while gold > 0:
		var randomNum = rng.randi_range(0, 0)
		if randomNum == 0 and gold >= 3:
			print("buying a minion")
			_buyMinion()
		else:
			print("done")
			break
	#var numCardsCreated = max(1, int(mainGameScreen.roomNum / 2))
	#var randomNumber = %masterLogicHandler.rng.randf()
	#var giveRandomBuffs = true
	#if(randomNumber <= 0.1):
		#numCardsCreated += 1
	#if fightScreen.isEliteFight and numCardsCreated < 7:
		#numCardsCreated += 1
		#giveRandomBuffs = false
	#numCardsCreated = min(numCardsCreated, 7)
	#for i in range(numCardsCreated):
		#_createRandomCard()
	#if fightScreen.isEliteFight and giveRandomBuffs:
		#var randomBonus = randi_range(1, int(mainGameScreen.roomNum / 3))
		#for i in range(randomBonus):
			#getRandomCard()._givePlus1Plus1()
			
func _buyMinion():
	gold -= 3
	var numCards = get_child_count()
	if numCards >= 7:
		print("selling minion")
		_sellMinion()
	var newCard
	var threshhold = 0
	var randomNumber = rng.randi_range(0, totalNumCardsInPool - 1)
	for card in %masterLogicHandler.neutralCardLibrary:
		if randomNumber >= threshhold and randomNumber < threshhold + card.numLeftInPool:
			newCard = createCard(card)
			card.numLeftInPool -= 1
			totalNumCardsInPool -= 1
			newCard._WhenPlayed()
			print(newCard.CARD_TYPE, newCard.numLeftInPool)
			return
		else:
			threshhold += card.numLeftInPool
	var retVal = createNonNeutralCard(isWitchFight, MasterLogicHandler.witchCardLibrary, randomNumber, threshhold)
	if retVal == null:
		retVal = createNonNeutralCard(isMonkeFight, MasterLogicHandler.monkeCardLibrary, randomNumber, threshhold)
	if retVal == null:
		retVal = createNonNeutralCard(isDwarfFight, MasterLogicHandler.dwarfCardLibrary, randomNumber, threshhold)
	threshhold = retVal[0] # there's gotta be a better way to do this
	newCard = retVal[1]
	print(newCard.CARD_TYPE, newCard.numLeftInPool)
	newCard._WhenPlayed()

func createNonNeutralCard(isXFight, library, randomNumber, threshhold):
	if isXFight:
		for card in library:
			if randomNumber >= threshhold and randomNumber < threshhold + card.numLeftInPool:
				card.numLeftInPool -= 1
				totalNumCardsInPool -= 1
				return [threshhold, createCard(card)]
			else:
				threshhold += card.numLeftInPool
	else:
		return null

func _sellMinion():
	if synergies.max() == 0:
		_sellLowestStatMinion()
	_relocateCards()

func _sellLowestStatMinion():
	var min = 9223372036854775807
	var lowestCard
	for card in get_children():
		if card.attack + card.health < min:
			lowestCard = card
			min = card.attack + card.health
	lowestCard.numLeftInPool += 1
	totalNumCardsInPool += 1
	print(lowestCard.CARD_TYPE, lowestCard.numLeftInPool)
	lowestCard.free()
	gold += 1

func _obscureCards():
	var shadowLevel = %masterLogicHandler.mainCharacter.shadowLevel
	while get_child_count() < shadowLevel:
		createCard(MysteryCard.new())
	for i in range(shadowLevel):
		if not get_child(i) is MysteryCard:
			_makeMysterySprite(i)
	
func _makeMysterySprite(childNum):
	var spr = Sprite2D.new()
	var card = get_child(childNum)
	spr.name = "MysteryCard"
	spr.texture = load("res://Cards/MysteryCard/MysteryCard.png")
	spr.z_index = 2
	card.add_child(spr)
	card.hasFullArt = false

func _removeMysterySprites():
	for i in range(MasterLogicHandler.mainCharacter.shadowLevel):
		_removeMysterySprite(i)
	_relocateCards()
	
func _removeMysterySprite(childNum):
	var card = get_child(childNum)
	if card is MysteryCard:
		card.free()
	else:
		if card:
			for child in card.get_children():
				if child.name == "MysteryCard":
					child.free()
				card.hasFullArt = true

func createRandomCard():
	var neutralCardPoolSize = MasterLogicHandler.neutralCardLibrary.size()
	var cardPoolSize = neutralCardPoolSize
	if isWitchFight:
		cardPoolSize += MasterLogicHandler.witchCardLibrary.size()
	if isMonkeFight:
		cardPoolSize += MasterLogicHandler.monkeCardLibrary.size()
	if isDwarfFight:
		cardPoolSize += MasterLogicHandler.dwarfCardLibrary.size()
	var randomNum = %masterLogicHandler.rng.randi_range(0, cardPoolSize - 1)
	if randomNum < neutralCardPoolSize:
		return createCard(%masterLogicHandler.neutralCardLibrary[randomNum])
	else:
		if isWitchFight:
			return createCard(%masterLogicHandler.witchCardLibrary[randomNum - neutralCardPoolSize])
		if isMonkeFight:
			return createCard(%masterLogicHandler.monkeCardLibrary[randomNum - neutralCardPoolSize])
		if isDwarfFight:
			return createCard(%masterLogicHandler.dwarfCardLibrary[randomNum - neutralCardPoolSize])
