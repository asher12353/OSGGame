extends Artifact
class_name SpyGlass

func _init():
	artifactArtPath = "res://Artifacts/SpyGlass/Spyglass-1-580x386.jpg"

func _WhenAcquired():
	_Artifact()
	MasterLogicHandler.mainCharacter.shadowLevel -= 1
