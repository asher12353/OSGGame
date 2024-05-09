extends Room

var cost = 5

func _event():
	if MasterLogicHandler.mainCharacter.money >= cost:
		MasterLogicHandler._updateMoney(-cost)
		MasterLogicHandler.mainCharacter._updateHealth(1)
