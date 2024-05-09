extends Card
class_name Hair

static var CARD_TYPE = 2006
static var numLeftInPool = 0

func _init():
	nameString = "Strand of Hair"
	attack = 0
	health = 1
	isOffering = true
	cardArtPath = "res://Cards/WitchCardLibrary/Hair/Hair.png"
	fullArtPath = "res://Cards/WitchCardLibrary/Hair/HairFull.png"
	_updateText()
	_updateSpellText()
	MasterLogicHandler.mainCharacter.curse_power_changed.connect(Callable(self, "_onCursePowerChanged"))
	curseSynergy = 1
	synergies[curseSynergyIndex] = curseSynergy
	_Card()

func _whenSpellIsCrafted(spell):
	spell.isTargeted = true

func _spellEffect(target):
	var cursepower = MasterLogicHandler.mainCharacter.cursePower
	target._giveStats(-(1 + cursepower), -(1 + cursepower))

func _updateSpellText():
	if MasterLogicHandler and MasterLogicHandler.mainCharacter:
		var cursepower = MasterLogicHandler.mainCharacter.cursePower
		spellText = "Give a minion -%d/-%d" % [1 + cursepower, 1 + cursepower]
	else:
		spellText = "Give a minion -1/-1"
		
func _updateText():
	if MasterLogicHandler and MasterLogicHandler.mainCharacter:
		var cursepower = MasterLogicHandler.mainCharacter.cursePower
		textString = "Offering: Give a minion -%d/-%d" % [1 + cursepower, 1 + cursepower]
	else:
		textString = "Offering: Give a minion -1/-1"

func _onCursePowerChanged():
	_updateSpellText()
	_updateText()
	_updateLabel(textLabel, textString)
