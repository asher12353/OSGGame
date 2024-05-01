extends Control

@onready var resOptionButton = $HBoxContainer/VBoxContainer/ResolutionOptionButton
@onready var fullScreenCheckBox = $HBoxContainer/VBoxContainer/FullScreenCheckBox
@onready var label = $HBoxContainer/VBoxContainer/HBoxContainer/Label
@onready var h_slider = $HBoxContainer/VBoxContainer/HBoxContainer/HSlider

var Resolutions : Dictionary = {
	"3840x2160":Vector2i(3840,2160),
	"2560x1440":Vector2i(2560,1440),
	"1920x1080":Vector2i(1920,1080),
	"1366x768":Vector2i(1366,768),
	"1536x864":Vector2i(1536,864),
	"1280x720":Vector2i(1280,720),
	"1440x900":Vector2i(1440,900),
	"1600x900":Vector2i(1600,900),
	"1024x600":Vector2i(1024,600),
	"800x600":Vector2i(800,600)
}

func _ready():
	_addResolutions()
	_checkVariables()

func _checkVariables():
	var _window = get_window()
	var mode = _window.get_mode()
	
	if mode == Window.MODE_FULLSCREEN:
		fullScreenCheckBox.set_pressed_no_signal(true)

func _setResolutionText():
	var resolutionText = str(get_window().get_size().x) + "x" + str(get_window().get_size().y)
	resOptionButton.set_text(resolutionText)

func _addResolutions():
	var currentResolution = get_window().get_size()
	var ID = 0
	for r in Resolutions:
		resOptionButton.add_item(r, ID)
		if Resolutions[r] == currentResolution:
			resOptionButton.select(ID)
		ID += 1

func _centreWindow():
	var centreScreen = DisplayServer.screen_get_position() + DisplayServer.screen_get_size()/2
	var windowSize = get_window().get_size_with_decorations()
	get_window().set_position(centreScreen - windowSize/2)


func _on_full_screen_check_box_toggled(toggled_on):
	if toggled_on:
		get_window().set_mode(Window.MODE_FULLSCREEN)
	else:
		get_window().set_mode(Window.MODE_WINDOWED)
		_centreWindow()
	get_tree().create_timer(0.05).timeout.connect(_setResolutionText)


func _on_resolution_option_button_item_selected(index):
	var ID = resOptionButton.get_item_text(index)
	get_window().set_size(Resolutions[ID])
	_centreWindow()


func _on_h_slider_value_changed(value):
	var resolutionScale = value/100.00
	var resolutionText = str(round(get_window().get_size().x * resolutionScale)) + "x" + str(round(get_window().get_size().y * resolutionScale))
	label.set_text(str(value) + "% - " + resolutionText)
	get_viewport().set_scaling_3d_scale(resolutionScale)


func _on_button_pressed():
	hide()
