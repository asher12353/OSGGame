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
	fullAttackLabel.hide()
	fullHealthLabel.hide()
	
func _playSpell(_target):
	print("here?")
	pass

func _process(delta):
	if targetLocation != null and is_dragging != true:
		position = lerp(position, targetLocation, speed * delta)
	if is_dragging and board and position.y < board.boardY - 210:
		hide()
		if isTargeted:
			Input.set_custom_mouse_cursor(targetCursor)
			if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and Card.mouseIsHoveredOver and not Card.mouseIsHoveredOver is Spell:
				_playSpell(Card.mouseIsHoveredOver)
				if get_parent() == playerHand:
					playerHand.remove_child(self)
				playerHand._relocateCards()
				return
	else:
		show()
		if isTargeted:
			Input.set_custom_mouse_cursor(null)
	#if is_visible_in_tree():
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
	
