extends Screen
@export var mainGameScreen : Screen
@export var globalUIElements : Control


func _on_witch_select_pressed():
	var witch = Witch.new()
	%masterLogicHandler._changeScreen(mainGameScreen)
	globalUIElements.show()
	%masterLogicHandler._setMainCharacter(witch)
	globalUIElements._updateMoneyLabel(%masterLogicHandler.mainCharacter.money)
	
