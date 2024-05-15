extends Board

@export var playerShopBoard : Board

func _ready():
	boardY = playerShopBoard.boardY

func _instantiateBoard():
	var cards = playerShopBoard.get_children()
	for card in cards:
		createCard(card)
	MasterLogicHandler._relocateCardDropZones()
