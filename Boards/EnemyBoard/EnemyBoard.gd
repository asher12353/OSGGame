extends Board
class_name EnemyBoard

func _ready():
	boardY = -140
	

# this is where the big fancy algorithm will be written later
func _instantiateBoard():
	_createRandomCard()
	
func _createRandomCard():
	var randomNum = %masterLogicHandler.rng.randi_range(0, numDifferentCards - 1)
	if randomNum == 0:
		_createCard(Frg.new())
	elif randomNum == 1:
		_createCard(OctoBro.new())
	else:
		assert(false, "You forgot to add a card to _createRandomCard() in EnemyBoard dumbass")
	
