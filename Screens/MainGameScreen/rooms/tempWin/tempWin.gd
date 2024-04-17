extends Screen

var lh : LogicHandler

func _ready():
	lh = get_node("/root/main/masterLogicHandler")


func _on_button_pressed():
	var parent = get_parent()
	parent.endlessMode = true
	parent.isShop = true
	parent._changeScreenToNextRoom()
