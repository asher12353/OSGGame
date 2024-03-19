extends Node2D

@export var healthBar : ProgressBar
@export var moneyLabel : RichTextLabel

func _updateHealthBar(newHealth):
	healthBar.value = newHealth

func _updateMoneyLabel(newMoney):
	moneyLabel.text = "Money: {newMoney}".format({"newMoney" : newMoney})
