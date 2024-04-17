extends Card
class_name Spawn

static var CARD_TYPE = 1000

func _init():
	attack = 2
	health = 2
	cardArtPath = "res://Cards/uniqueCardLibrary/Spawn/Spawn_of_N'Zoth_full.png"
	fullArtPath = "res://Cards/UniqueCardLibrary/Spawn/Spawn_of_N'Zoth_fuller.png"
	nameString = "Spawn of N'zoth"
	textString = "When it dies: \nGive your minions +1/+1"
	whenItDiesSynergy = true
	_Card()
	
func _WhenItDies():
	for card in board.get_children():
		if not card == self:
			card._givePlus1Plus1()
