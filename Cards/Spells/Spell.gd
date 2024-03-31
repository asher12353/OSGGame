extends Card
class_name Spell

var targetCursor = load("res://UI/target.png")
var isTargeted : bool
var playerHand : Board

func _Spell():
	attack = 0
	health = 0
	_Card()
	attackLabel.hide()
	healthLabel.hide()
	
func _playSpell(target):
	print("here?")
	pass

func _process(_delta):
	if global_position.y < board.boardY - 210:
		hide()
		if isTargeted:
			Input.set_custom_mouse_cursor(targetCursor)
			if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				print(Card.mouseIsHoveredOver)
				_playSpell(Card.mouseIsHoveredOver)
	else:
		show()
		if isTargeted:
			Input.set_custom_mouse_cursor(null)
	if is_draggable:
		_startDraggingCard()
		# or
		_stopDraggingCard()
	if is_dragging:
		global_position = get_global_mouse_position()
	
