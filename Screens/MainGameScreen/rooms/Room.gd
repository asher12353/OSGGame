extends Screen
class_name Room

var buttonContainer

func _Room():
	buttonContainer = find_child("VBoxContainer")
	buttonContainer.position = Vector2(MasterLogicHandler.globalUIElements.artifactContainer.size.x, buttonContainer.position.y)
