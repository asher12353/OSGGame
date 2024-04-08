extends Card
class_name Newt

static var numLeftInPool : int = 20
static var CARD_TYPE = 2004

func _init():
	attack = 2
	health = 2
	isReagent = true
	cardArtPath = "res://Cards/WitchCardLibrary/Newt/Newt.png"
	fullArtPath = "res://Cards/WitchCardLibrary/Newt/NewtFull.png"
	nameString = "Newt"
	textString = "Reagent: Give a minion +1/+1"
	_Card()

func _whenSpellIsCrafted(spell):
	spell.isTargeted = true

func _spellEffect(target):
	target._givePlus1Plus1()
