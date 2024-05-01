extends Screen
@export var characterSelectScreen : Screen
@export var options : Control

func _on_start_button_pressed():
	%masterLogicHandler._changeScreen(characterSelectScreen)
	pass # Replace with function body.

func _on_exit_button_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_options_button_pressed():
	options.show()
