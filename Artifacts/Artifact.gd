extends Node2D
class_name Artifact

var artifactArtPath : String
var artifactArt : TextureRect

static var artifactContainer : VBoxContainer

func _ready():
	artifactContainer = MasterLogicHandler.globalUIElements.find_child("artifactContainer")

func _Artifact():
	_makeArtifactTextureRect()

func _makeArtifactTextureRect():
	artifactArt = TextureRect.new()
	artifactArt.texture = load(artifactArtPath)
	artifactContainer.add_child(artifactArt)

func _WhenAcquired():
	pass
