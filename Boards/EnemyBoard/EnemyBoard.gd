extends Board
class_name EnemyBoard

@export var fightScreen : Screen

var mainGameScreen : Screen
var totalNumCardsInPool
var rng
var mysteryArtScale = Vector2(1.05, 1.10)

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
var whenItAttacksSynergy = 0
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
  whenItAttacksSynergy,
  hitmanSynergy,
  forgeSynergy,
  investSynergy
]
var gold : int

func _ready():
	boardY = -140
	mainGameScreen = %masterLogicHandler.mainGameScreen
	fightScreen = MasterLogicHandler.fightScreen
	rng = MasterLogicHandler.rng

func _updatePool():
	totalNumCardsInPool = 0
	for card in MasterLogicHandler.neutralCardLibrary:
		totalNumCardsInPool += card.numLeftInPool
	_updatePoolForXLibrary(isWitchFight, MasterLogicHandler.witchCardLibrary)
	_updatePoolForXLibrary(isMonkeFight, MasterLogicHandler.monkeCardLibrary)
	_updatePoolForXLibrary(isDwarfFight, MasterLogicHandler.dwarfCardLibrary)

func _updatePoolForXLibrary(isXFight, library):
	if isXFight:
		for card in library:
			totalNumCardsInPool += card.numLeftInPool

# this is where the big fancy algorithm will be written later
func _instantiateBoard():
	print("alright, starting the enemies turn")
	for i in range(synergies.size()):
		synergies[i] = 0
	var roomNum = mainGameScreen.roomNum
	if fightScreen.isEliteFight:
		gold = 2 + int(pow(roomNum, 1.9) - roomNum * 1.8)
	else:
		gold = 3 + int(pow(roomNum, 1.7) - roomNum * 1.7)
	print(gold)
	_createTheCards()
	_obscureCards()
	for card in get_children():
		card.is_draggable_at_all = false

func _createTheCards():
	while gold > 0:
		var randomNum = rng.randi_range(0, 1)
		if randomNum == 0 and gold >= 3:
			_buyMinion()
		elif randomNum == 1 and gold >= 2:
			if get_child_count() != 0:
				var card = getRandomCard()
				if card != null:
					card._givePlus1Plus1()
					gold -= 2
		else:
			#print("done")
			break

# I know I don't normally orginize members like this, but I think I'll do this for "sudo global" variables that I want between at least two functions
# Just be sure to keep things orginized by keeping the members by the functions that they are used in
var threshhold = 0
var randomNumber = 0

func _buyMinion():
	gold -= 3
	var numCards = get_child_count()
	if numCards >= 7:
		#print("selling minion")
		_sellMinion()
	var newCard
	#print("buying a minion")
	threshhold = 0
	randomNumber = rng.randi_range(0, totalNumCardsInPool - 1)
	var retVal = makeNewCardFromLibrary(true, MasterLogicHandler.neutralCardLibrary)
	if retVal == null:
		retVal = makeNewCardFromLibrary(isWitchFight, MasterLogicHandler.witchCardLibrary)
	if retVal == null:
		retVal = makeNewCardFromLibrary(isMonkeFight, MasterLogicHandler.monkeCardLibrary)
	if retVal == null:
		retVal = makeNewCardFromLibrary(isDwarfFight, MasterLogicHandler.dwarfCardLibrary)
	newCard = retVal
	#if newCard is BlacksmithApprentice or newCard is MonkeWithBanana:
	#	print(newCard.nameString, newCard.numLeftInPool)
	newCard._WhenPlayed()
	_updateSynergies(newCard, true)
	#print(synergies)

func _updateSynergies(card, isBuying):
	if isBuying:
		for i in range(synergies.size()):
			synergies[i] += card.synergies[i]
	else:
		for i in range(synergies.size()):
			synergies[i] -= card.synergies[i]

func makeNewCardFromLibrary(isXFight, library): # -> Card
	if isXFight:
		for card in library:
			if randomNumber >= threshhold and randomNumber < threshhold + card.numLeftInPool:
				card.numLeftInPool -= 1
				totalNumCardsInPool -= 1
				return createCard(card)
			else:
				threshhold += card.numLeftInPool
	else:
		return null

func _sellMinion():
	if synergies.max() == 0:
		_sellLowestStatMinion(get_children())
	else:
		var lowestSynergyIndex = getLowestSynergy()
		var cards = getLowestSynergyMinions(lowestSynergyIndex)
		#print("selling lowest stat low synergy minion with synergy")
		#print(lowestSynergyIndex)
		#print("possible options:")
		#print(cards)
		_sellLowestStatMinion(cards)
	_relocateCards()

func getLowestSynergy() -> int:
	var minValue = 9223372036854775807
	var lowestSynergy
	var lowestSynergies = []
	for i in range(synergies.size()):
		if lowestSynergies.size() == 0 and synergies[i] <= minValue and synergies[i] != 0:
			minValue = synergies[i]
			lowestSynergies.append(i)
		elif synergies[i] < minValue and synergies[i] != 0:
			minValue = synergies[i]
			lowestSynergies = [i]
	lowestSynergy = lowestSynergies.pick_random()
	return lowestSynergy

func getLowestSynergyMinions(synergyIndex):
	var retArray = []
	for card in get_children():
		if card.hasNoSynergy:
			retArray.append(card)
	if not retArray.is_empty():
		return retArray
	for card in get_children():
		if card.synergies[synergyIndex] > 0:
			retArray.append(card)
	return retArray

func _sellLowestStatMinion(cards):
	var minValue = 9223372036854775807
	var lowestCard
	for card in cards:
		if card.attack + card.health < minValue:
			lowestCard = card
			minValue = card.attack + card.health
	lowestCard.numLeftInPool += 1
	totalNumCardsInPool += 1
	_updateSynergies(lowestCard, false)
	#print(lowestCard.nameString, lowestCard.numLeftInPool)
	lowestCard.free()
	gold += 1

func _obscureCards():
	var shadowLevel = %masterLogicHandler.mainCharacter.shadowLevel
	while get_child_count() < shadowLevel:
		var card = createCard(MysteryCard.new())
		card.cardArt.scale *= mysteryArtScale 
	for i in range(shadowLevel):
		var card = get_child(i)
		if not card is MysteryCard:
			_makeMysterySprite(i)
	
func _makeMysterySprite(childNum):
	var spr = Sprite2D.new()
	var card = get_child(childNum)
	spr.name = "MysteryCard"
	spr.texture = load("res://Cards/MysteryCard/MysteryCard.png")
	spr.scale = Card.artScale * mysteryArtScale
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


#######################################################ABANDONED CODE##########################################################

#func _createTheCards():
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
