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
	if MasterLogicHandler and MasterLogicHandler.mainCharacter:
		var spellpower = MasterLogicHandler.mainCharacter.spellPower
		spellText = "Give a minion +%d/+%d" % [1 + spellpower, 1 + spellpower]
	else:
		spellText = "Give a minion +1/+1"
	_Card()

func _whenSpellIsCrafted(spell):
	spell.isTargeted = true

func _spellEffect(target):
	target._givePlus1Plus1()
