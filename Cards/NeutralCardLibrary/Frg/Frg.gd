extends Card
class_name Frg

static var numLeftInPool : int = 20
static var CARD_TYPE = 1

func _init():
	attack = 2
	health = 1
	cardArtPath = "res://Cards/NeutralCardLibrary/Frg/FrgColored.png"
	fullArtPath = "res://Cards/NeutralCardLibrary/Frg/FrgColoredFull.png"
	nameString = "Frog"
	textString = "When Played: Gain 1 gold"
	whenPlayedSynergy = 1
	synergies[whenPlayedSynergyIndex] = whenPlayedSynergy
	_Card()
	

func _WhenPlayed():
	if board == MasterLogicHandler.playerShopBoard: 
		MasterLogicHandler._updateMoney(1)
	if board == MasterLogicHandler.enemyBoard:
		board.gold += 1
