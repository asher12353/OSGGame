extends Card
class_name MonkeWithBanana

static var numLeftInPool : int = 20
static var CARD_TYPE = 4000

func _init():
	attack = 3
	health = 1
	cardArtPath = "res://Cards/MonkeCardLibrary/MonkeWithBanana/MonkeWithBanana.png"
	fullArtPath = "res://Cards/MonkeCardLibrary/MonkeWithBanana/MonkeWithBananaFull.png"
	nameString = "Monke With a Banana"
	textString = "When Played: Add a\n banana to your hand"
	bananaSynergy = 1
	synergies[bananaSynergyIndex] = bananaSynergy
	whenPlayedSynergy = 1
	synergies[whenPlayedSynergyIndex] = whenPlayedSynergy
	_Card()

func _WhenPlayed():
	if board == MasterLogicHandler.playerShopBoard:
		MasterLogicHandler.playerHand.createCard(Banana.new())
	if board == MasterLogicHandler.enemyBoard:
		var banana = Banana.new()
		banana._playSpell(board.getRandomCard())
