extends Node2D
class_name Character

var gameOverScreen : Screen

var health = MasterLogicHandler.mainCharacterMaxHealth
var money = 300
var shopLevel = 1
var shadowLevel = 2 # this is how many cards are obscured

var artifacts = []

func _ready():
	gameOverScreen = get_node("/root/main/gameOverScreen")

func _acquireArtifact(artifact):
	artifacts.push_front(artifact)
	artifact._WhenAcquired()

func _updateHealth(value):
	health += value
	MasterLogicHandler.globalUIElements._updateHealthBar(health)
	if health <= 0:
		MasterLogicHandler._changeScreen(gameOverScreen)
