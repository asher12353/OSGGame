extends Screen

func _event():
	if MasterLogicHandler.mainCharacter.money >= 5:
		MasterLogicHandler._updateMoney(-5)
		MasterLogicHandler.mainCharacter.health += 1
		MasterLogicHandler.globalUIElements._updateHealthBar(MasterLogicHandler.mainCharacter.health)
