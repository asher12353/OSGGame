extends Screen
@export var characterSelectScreen : Screen



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_start_button_pressed():
	%masterLogicHandler._changeScreen(characterSelectScreen)
	pass # Replace with function body.


func _on_exit_button_pressed():
	get_tree().quit()
	pass # Replace with function body.
