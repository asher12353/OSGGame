extends Button
class_name RoomButton

var mainGameScreen : Screen

func _RoomButton(connection):
	mainGameScreen = get_node("/root/main/mainGameScreen")
	pressed.connect(Callable(mainGameScreen, connection))
