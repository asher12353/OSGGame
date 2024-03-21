extends Screen

var lh : LogicHandler

func _ready():
	lh = get_node("/root/main/masterLogicHandler")

func _event():
	lh._updateMoney(3)
