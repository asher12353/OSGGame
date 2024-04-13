extends Board
class_name EnemyBoard

@export var fightScreen : Screen

var mainGameScreen

func _ready():
	boardY = -140
	mainGameScreen = %masterLogicHandler.mainGameScreen

# this is where the big fancy algorithm will be written later
func _instantiateBoard():
	_createTheCards()
	_obscureCards()
	for card in get_children():
		card.is_draggable_at_all = false

func _createTheCards():
	var numCardsCreated = max(1, int(mainGameScreen.roomNum / 2))
	var randomNumber = %masterLogicHandler.rng.randf()
	var giveRandomBuffs = true
	if(randomNumber <= 0.1):
		numCardsCreated += 1
	if fightScreen.isEliteFight and numCardsCreated < 7:
		numCardsCreated += 1
		giveRandomBuffs = false
	numCardsCreated = min(numCardsCreated, 7)
	for i in range(numCardsCreated):
		_createRandomCard()
	if fightScreen.isEliteFight and giveRandomBuffs:
		var randomBonus = randi_range(1, int(mainGameScreen.roomNum / 3))
		for i in range(randomBonus):
			getRandomCard()._givePlus1Plus1()
	
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
	_removeMysterySprite(0)
	_removeMysterySprite(1)
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

func _createRandomCard():
	var randomNum = %masterLogicHandler.rng.randi_range(0, %masterLogicHandler.neutralCardLibrary.size() - 1)
	var card = createCard(%masterLogicHandler.neutralCardLibrary[randomNum])
	card._WhenPlayed()
