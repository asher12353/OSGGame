extends Room

func _event1():
	MasterLogicHandler.mainCharacter._updateHealth(1)
	
func _event2():
	MasterLogicHandler.currentShownBoard = MasterLogicHandler.playerShopBoard
	MasterLogicHandler.playerHand.createCard(Spawn.new())
	MasterLogicHandler.currentShownBoard = null
