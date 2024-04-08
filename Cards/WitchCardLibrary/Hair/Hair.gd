extends Card
class_name Hair

static var CARD_TYPE = 2006

func _init():
	attack = 0
	health = 1
	isOffering = true
	cardArtPath = "res://Cards/WitchCardLibrary/Hair/Hair.png"
	fullArtPath = "res://Cards/WitchCardLibrary/Hair/HairFull.png"
	nameString = "Strand of Hair"
	textString = "Offering: Give a minion -1/-1"
	_Card()

func _whenSpellIsCrafted(spell):
	spell.isTargeted = true

func _spellEffect(target):
	target._giveStats(-1, -1)
