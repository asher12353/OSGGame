extends Card
class_name Spell

var targetCursor = load("res://UI/target.png")
var isTargeted : bool

func _Spell():
	attack = 0
	health = 0
	_Card()
	attackLabel.hide()
	healthLabel.hide()
	
func _playSpell(_target):
	print("here?")
	pass

func _process(_delta):
	if global_position.y < board.boardY - 210:
		hide()
		if isTargeted:
			Input.set_custom_mouse_cursor(targetCursor)
			if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and Card.mouseIsHoveredOver:
				print(Card.mouseIsHoveredOver)
				_playSpell(Card.mouseIsHoveredOver)
	else:
		show()
		if isTargeted:
			Input.set_custom_mouse_cursor(null)
	if is_visible_in_tree():
		var mouse_pos = get_global_mouse_position()
		if isMouseOver(mouse_pos):
			_setDraggable(true)
			if timerCanBeStarted():
				hoverTimer.start(hoverCooldown)
		else:
			_setDraggable(false)
			fullArtNode.hide()
			if not hoverTimer.is_stopped():
				hoverTimer.stop()
		if is_draggable:
			_startDraggingCard()
			# or
			_stopDraggingCard()
		if is_dragging:
			global_position = mouse_pos
			fullArtNode.hide()
	
