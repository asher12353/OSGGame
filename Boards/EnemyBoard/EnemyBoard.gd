extends Board
class_name EnemyBoard

func _ready():
	boardY = -140
	

# this is where the big fancy algorithm will be written later
func _instantiateBoard():
	var randomNumber = %masterLogicHandler.rng.randf()
	if(randomNumber <= 0.1):
		_createRandomCard()
	_createRandomCard()
	_hideCards()
	for card in get_children():
		card.is_draggable_at_all = false
	
func _hideCards():
	while get_child_count() < 2:
		_createCard(MysteryCard.new())
	if not get_child(0) is MysteryCard:
		_makeMysterySprite(0)
	if not get_child(1) is MysteryCard:
		_makeMysterySprite(1)
	
func _makeMysterySprite(childNum):
	var spr = Sprite2D.new()
	spr.name = "MysteryCard"
	spr.texture = load("res://Cards/MysteryCard/MysteryCard.png")
	spr.position = get_child(childNum).get_position()
	spr.top_level = true
	get_child(childNum).add_child(spr)

func _removeMysterySprites():
	_removeMysterySprite(0)
	_removeMysterySprite(1)
	_relocateCards()
	
func _removeMysterySprite(childNum):
	if get_child(childNum) is MysteryCard:
		get_child(childNum).free()
	else:
		for child in get_child(childNum).get_children():
			if child.name == "MysteryCard":
				child.free()

func _createRandomCard():
	var randomNum = %masterLogicHandler.rng.randi_range(0, %masterLogicHandler.differentKindsOfCards.size() - 1)
	_createCard(%masterLogicHandler.differentKindsOfCards[randomNum])
	
