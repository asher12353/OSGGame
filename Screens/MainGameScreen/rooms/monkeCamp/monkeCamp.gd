extends Room

func _event():
	MasterLogicHandler.playerHand.createCard(Banana.new())
