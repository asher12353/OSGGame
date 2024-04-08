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
	for offering in offerings:
		if isTargeted:
			offering._spellEffect(target)
		else:
			offering._spellEffect()
	queue_free()
	Input.set_custom_mouse_cursor(null)
