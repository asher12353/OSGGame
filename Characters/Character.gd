extends Node2D
class_name Character

var gameOverScreen : Screen
var fightScreen : Screen

var health = MasterLogicHandler.mainCharacterMaxHealth
var money = 3
var shopLevel = 1
var shadowLevel = 2 # this is how many cards are obscured

var artifacts = []

func _ready():
	gameOverScreen = get_node("/root/main/gameOverScreen")
	fightScreen = get_node("/root/main/fightScreen")

func _acquireArtifact(artifact):
	artifacts.push_front(artifact)
	artifact._WhenAcquired()

func _updateHealth(value):
	health += value
	fightScreen.anteSlider.max_value = health
	MasterLogicHandler.globalUIElements._updateHealthBar(health)
	if health <= 0:
		MasterLogicHandler._changeScreen(gameOverScreen)
