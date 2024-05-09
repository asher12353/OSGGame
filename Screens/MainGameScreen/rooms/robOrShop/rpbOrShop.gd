extends Room

var reward = 3

func _event():
	MasterLogicHandler._updateMoney(reward)
