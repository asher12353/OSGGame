extends Screen

@export var playerShopBoard : Board
@export var npcShopBoard : Board
@export var playerHand : Board
@export var upgradeShopButton : Button
@export var mainGameScreen : Screen

var cardInSellArea : Card
var cardInBuyArea : Card

var upgradeShopCost = 10

func _initialize():
	_showBoards()
	npcShopBoard._refreshBoard()
	%masterLogicHandler.cardsAreMovable = true
	_updateUpgradeButton()
	
func _showBoards():
	playerHand.show()
	playerShopBoard.show()
	%masterLogicHandler.currentShownBoard = playerShopBoard
	npcShopBoard.show()
	
func _hideBoards():
	playerHand.hide()
	playerShopBoard.hide()
	%masterLogicHandler.currentShownBoard = null
	npcShopBoard.hide()

func _process(_delta):
	if cardCanBeSold():
		_sellCard()
	if cardCanBeBought():
		_buyCard()

func cardCanBeSold() -> bool:
	var expression = cardInSellArea and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	if expression and cardInSellArea.board == playerHand:
		MasterLogicHandler.globalUIElements._displayAlert("You cannot sell from your hand\nPlace it on the board before selling")
	return expression and cardInSellArea.board == playerShopBoard

func cardCanBeBought() -> bool:
	var expression = cardInBuyArea and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and cardInBuyArea.board == npcShopBoard
	if expression and MasterLogicHandler.mainCharacter.money < 3:
		MasterLogicHandler.globalUIElements._displayAlert("You do not have enough money")
	return expression and %masterLogicHandler.mainCharacter.money >= 3

func _sellCard():
	var board = cardInSellArea.board
	if cardInSellArea.cursePower > 0:
		cardInSellArea.free()
		MasterLogicHandler.mainCharacter.cursePower = playerShopBoard.getTotalCursePower()
		MasterLogicHandler.mainCharacter.emit_signal("curse_power_changed")
	else:
		cardInSellArea.free()
	%masterLogicHandler._updateMoney(1)
	board._relocateCards()
	cardInSellArea = null

func _buyCard():
	cardInBuyArea._changeBoard(playerHand)
	%masterLogicHandler._updateMoney(-3)
	playerHand._relocateCards()
	npcShopBoard._relocateCards()
	cardInBuyArea = null
	
func _updateUpgradeButton():
	upgradeShopButton.text = "Level: {level}\nUpgrade: {upgradeShopCost}".format({"upgradeShopCost":upgradeShopCost, "level":%masterLogicHandler.mainCharacter.shopLevel})

func _on_sell_area_area_entered(area):
	cardInSellArea = area

func _on_sell_area_area_exited(_area):
	cardInSellArea = null

func _on_buy_area_area_entered(area):
	if area is Card:
		cardInBuyArea = area

func _on_buy_area_area_exited(_area):
	cardInBuyArea = null

func _on_refresh_button_pressed():
	if %masterLogicHandler.mainCharacter.money >= 1:
		npcShopBoard._refreshBoard()
		%masterLogicHandler._updateMoney(-1)

func _on_upgrade_shop_button_pressed():
	var character = %masterLogicHandler.mainCharacter
	if character.money >= upgradeShopCost:
		%masterLogicHandler._updateMoney(-upgradeShopCost)
		character.shopLevel += 1
		upgradeShopCost += character.shopLevel
		_updateUpgradeButton()

func _on_leave_shop_button_pressed():
	_hideBoards()
	hide()
	%masterLogicHandler._changeScreen(mainGameScreen)
