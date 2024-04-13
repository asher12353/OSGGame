extends Screen

var lh : LogicHandler

func _ready():
	lh = get_node("/root/main/masterLogicHandler")

func _event1():
	lh.mainCharacter.health += 1
	lh.globalUIElements._updateHealthBar(lh.mainCharacter.health)
	
func _event2():
	lh.currentShownBoard = lh.playerShopBoard
	lh.playerShopBoard.createCard(Spawn.new())
	lh.currentShownBoard = null
