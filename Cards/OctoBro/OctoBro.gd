extends Card
class_name OctoBro

static var numLeftInPool : int = 20

func _init():
	attack = 1
	health = 1
	cardArtPath = "res://Cards/OctoBro/OctoBroColored.png"
	_Card()

func _WhenPlayed():
	if board.get_child_count() == 1:
		return
	var randomCard = board.get_child(MasterLogicHandler.rng.randi_range(0, board.get_child_count() - 1)) as Card
	while randomCard == self:
		randomCard = board.get_child(MasterLogicHandler.rng.randi_range(0, board.get_child_count() - 1)) as Card
	randomCard.attack += 1
	randomCard.health += 1
	randomCard._updateStatLabels()
