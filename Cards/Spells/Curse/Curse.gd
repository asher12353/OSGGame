extends Spell
class_name Curse

var offerings = []

func _init():
	nameString = "Curse"
	cardArtPath = "res://Cards/Spells/Curse/Curse.png"
	fullArtPath = "res://Cards/Spells/Curse/CurseFull.png"
	MasterLogicHandler.mainCharacter.curse_power_changed.connect(Callable(self, "_onCursePowerChanged"))
	_Spell()
	_updateSpellText()

func _playSpell(target : Card):
	if target.isEffigy and target.imbuedCurses.get_child_count() < target.effigyValue:
		_imbueCurse(target)
		return
	_playSpellEffects(target)
	if target.health <= 0:
		MasterLogicHandler.fightScreen._kill(target)
	queue_free()
	Input.set_custom_mouse_cursor(null)

func _onCursePowerChanged():
	_updateSpellText()

func _updateSpellText():
	textString = ""
	for offering in offerings:
		offering._updateSpellText()
		textString = textString + "\n" + offering.spellText
	_updateLabel(textLabel, textString)

func _imbueCurse(target : Card):
	reparent(target.imbuedCurses)
	is_dragging = false
	is_draggable_at_all = false
	Card.dragged_card = null
	Input.set_custom_mouse_cursor(null)

func _playSpellEffects(target : Card):
	for offering in offerings:
		if isTargeted:
			offering._spellEffect(target)
		else:
			offering._spellEffect()
