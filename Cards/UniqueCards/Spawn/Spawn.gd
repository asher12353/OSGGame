extends Card
class_name Spawn

static var numLeftInPool : int = 20
static var CARD_TYPE = 1000

func _init():
	attack = 2
	health = 2
	cardArtPath = "res://Cards/UniqueCards/Spawn/Spawn_of_N'Zoth_full.png"
	_Card()
	
func _WhenItDies():
	for card in board.get_children():
		if not card == self:
			card.attack += 1
			card.health += 1
			card._updateStatLabels()
