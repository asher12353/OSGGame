extends Button
class_name RoomButton

var mainGameScreen : Screen

func _RoomButton(connection):
	mainGameScreen = get_parent().get_parent()
	pressed.connect(Callable(mainGameScreen, connection))
