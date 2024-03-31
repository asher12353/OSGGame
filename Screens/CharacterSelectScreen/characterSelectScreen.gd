extends Screen
@export var mainGameScreen : Screen
@export var globalUIElements : Node2D # may change this to screen later, depending on what's fitting


func _on_witch_select_pressed():
	var witch = Witch.new()
	%masterLogicHandler._changeScreen(mainGameScreen)
	globalUIElements.show()
	%masterLogicHandler._setMainCharacter(witch)
	globalUIElements._updateMoneyLabel(%masterLogicHandler.mainCharacter.money)
	
