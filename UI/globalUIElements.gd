extends Control

@export var healthBar : ProgressBar
@export var moneyLabel : RichTextLabel
@export var pauseContainer : VBoxContainer
@export var artifactContainer : VBoxContainer
@onready var tooltip_alert = $tooltipAlert

var fadeRate = 1
var opacity = 0.0

func _ready():
	healthBar.max_value = MasterLogicHandler.mainCharacterMaxHealth
	
func _process(delta):
	if opacity > 0:
		opacity = opacity - delta * fadeRate
		if opacity <= 1.0:
			tooltip_alert.modulate = Color(1, 1, 1, opacity)
			if opacity >= -0.05 and opacity <= 0.05:
				tooltip_alert.text = ""

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = not get_tree().paused
		pauseContainer.visible = not pauseContainer.visible

func _updateHealthBar(newHealth):
	healthBar.value = newHealth

func _updateMoneyLabel(newMoney):
	moneyLabel.text = "Money: {newMoney}".format({"newMoney" : newMoney})

func _on_resume_button_pressed():
	get_tree().paused = false
	pauseContainer.visible = false


func _on_exit_button_pressed():
	get_tree().quit()

func _displayAlert(string : String):
	tooltip_alert.text = "[center]" + string + "[/center]"
	tooltip_alert.modulate = Color(1, 1, 1, 1)
	opacity = 2.0
