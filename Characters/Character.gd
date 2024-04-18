extends Node2D
class_name Character

var health = MasterLogicHandler.mainCharacterMaxHealth
var money = 3
var shopLevel = 1
var shadowLevel = 2 # this is how many cards are obscured

var artifacts = []

func _acquireArtifact(artifact):
	artifacts.push_front(artifact)
	artifact._WhenAcquired()
