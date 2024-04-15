extends Spell
class_name Curse

var offerings = []

func _init():
	cardArtPath = "res://Cards/Spells/Curse/Curse.png"
	fullArtPath = "res://Cards/Spells/Curse/CurseFull.png"
	nameString = "Curse"
	MasterLogicHandler.mainCharacter.curse_power_changed.connect(Callable(self, "_onCursePowerChanged"))
	_Spell()

func _playSpell(target):
	if target.isEffigy and target.imbuedCurses.get_child_count() < target.effigyValue:
		reparent(target.imbuedCurses)
		#global_position.y = 500 # replace with dynamic resolution value later
		#hide()
		is_dragging = false
		is_draggable_at_all = false
		Card.dragged_card = null
		Input.set_custom_mouse_cursor(null)
		return
	for offering in offerings:
		if isTargeted:
			offering._spellEffect(target)
		else:
			offering._spellEffect()
	if target.health <= 0:
		MasterLogicHandler.fightScreen._kill(target)
	queue_free()
	Input.set_custom_mouse_cursor(null)

func _onCursePowerChanged():
	textString = ""
	for offering in offerings:
		offering._updateSpellText()
		textString = textString + "\n" + offering.spellText
	_updateLabel(textLabel, textString)
