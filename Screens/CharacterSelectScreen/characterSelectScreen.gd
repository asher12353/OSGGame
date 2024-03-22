extends Screen
@export var mainGameScreen : Screen
@export var globalUIElements : Node2D # may change this to screen later, depending on what's fitting


func _on_witch_select_pressed():
	%masterLogicHandler._changeScreen(mainGameScreen)
	globalUIElements.show()
	%masterLogicHandler._setMainCharacter(Witch.new())
	globalUIElements._updateMoneyLabel(%masterLogicHandler.mainCharacter.money)
	
