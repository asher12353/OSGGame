extends Screen
@export var mainGameScreen : Screen
@export var globalUIElements : Control


func _on_witch_select_pressed():
	var witch = Witch.new()
	MasterLogicHandler._changeScreen(mainGameScreen)
	globalUIElements.show()
	%masterLogicHandler._setMainCharacter(witch) # can't figure out why right now, but this really wants to be %master instead of Master
	globalUIElements._updateMoneyLabel(MasterLogicHandler.mainCharacter.money)
	
