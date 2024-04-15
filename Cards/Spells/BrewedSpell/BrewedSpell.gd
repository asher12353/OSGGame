extends Spell
class_name BrewedSpell

var reagents = []

func _init():
	cardArtPath = "res://Cards/Spells/BrewedSpell/BrewedSpell.png"
	fullArtPath = "res://Cards/Spells/BrewedSpell/BrewedSpellFull.png"
	nameString = "Brewed Spell"
	textString = ""
	#for reagent in reagents:
		#reagent._updateSpellText()
		#textString = textString + "\n" + reagent.spellText
	_Spell()

func _playSpell(target):
	for reagent in reagents:
		if isTargeted:
			reagent._spellEffect(target)
		else:
			reagent._spellEffect()
	queue_free()
	Input.set_custom_mouse_cursor(null)
