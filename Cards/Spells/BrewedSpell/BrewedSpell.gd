extends Spell
class_name BrewedSpell

var reagents = []

func _init():
	nameString = "Brewed Spell"
	textString = ""
	cardArtPath = "res://Cards/Spells/BrewedSpell/BrewedSpell.png"
	fullArtPath = "res://Cards/Spells/BrewedSpell/BrewedSpellFull.png"
	_Spell()

func _playSpell(target):
	for reagent in reagents:
		if isTargeted:
			reagent._spellEffect(target)
		else:
			reagent._spellEffect()
	queue_free()
	Input.set_custom_mouse_cursor(null)
