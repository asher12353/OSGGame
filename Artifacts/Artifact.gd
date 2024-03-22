extends Node2D
class_name Artifact

var artifactContainer : VBoxContainer
var artifactArtPath : String
var artifactArt : TextureRect

func _Artifact():
	artifactContainer = MasterLogicHandler.globalUIElements.get_child(2) # gotta be a better way than this but feeling lazy rn
	artifactArt = TextureRect.new()
	artifactArt.texture = load(artifactArtPath)
	artifactContainer.add_child(artifactArt)

func _WhenAcquired():
	pass
