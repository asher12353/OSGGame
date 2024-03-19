extends Card
class_name Frg

func _init():
	attack = 2
	health = 1
	cardArtPath = "res://Cards/Frg/FrgColored.png"
	_Card()

func _WhenPlayed():
	MasterLogicHandler._updateMoney(1)
