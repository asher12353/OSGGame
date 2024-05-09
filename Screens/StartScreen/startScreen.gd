extends Screen
@export var characterSelectScreen : Screen
@export var options : Control

func _on_start_button_pressed():
	MasterLogicHandler._changeScreen(characterSelectScreen)

func _on_exit_button_pressed():
	get_tree().quit()

func _on_options_button_pressed():
	options.show()
	hide()
