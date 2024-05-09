extends Control

@export var healthBar : ProgressBar
@export var moneyLabel : RichTextLabel
@export var pauseContainer : TabContainer
@export var artifactContainer : VBoxContainer

func _ready():
	healthBar.max_value = MasterLogicHandler.mainCharacterMaxHealth

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
