extends Spell
class_name Curse

var offerings = []

func _init():
	cardArtPath = "res://Cards/Spells/Curse/Curse.png"
	fullArtPath = "res://Cards/Spells/Curse/CurseFull.png"
	nameString = "Curse"
	_Spell()
	textString = "THIS NEEDS TO BE UPDATED"

func _playSpell(target):
	if target.isEffigy and target.imbuedCurses.get_child_count() < target.effigyValue:
		reparent(target.imbuedCurses)
		#global_position.y = 500 # replace with dynamic resolution value later
		#hide()
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
