extends Screen
@export var characterSelectScreen : Screen
@export var options : Control
@onready var start_button = $VBoxContainer/startButton
@onready var v_box_container = $VBoxContainer

func _ready():
	if FileAccess.file_exists("user://save.save"):
		var file = FileAccess.open("user://save.save", FileAccess.READ)
		if file.get_length() == 0:
			return
		var continueButton = Button.new()
		continueButton.text = "Continue"
		continueButton.pressed.connect(_on_continue_button_pressed)
		v_box_container.add_child(continueButton)
		v_box_container.move_child(continueButton, 0)
		start_button.text = "New Game"

func _on_continue_button_pressed():
	MasterLogicHandler._loadGame()
	#MasterLogicHandler._changeScreen(characterSelectScreen)

func _on_start_button_pressed():
	MasterLogicHandler._clearSave()
	MasterLogicHandler._changeScreen(characterSelectScreen)

func _on_exit_button_pressed():
	get_tree().quit()

func _on_options_button_pressed():
	options.show()
	hide()
