extends Spell
class_name Banana

func _init():
	cardArtPath = "res://Cards/Spells/Banana/Banana.png"
	fullArtPath = "res://Cards/Spells/Banana/BananaFull.png"
	nameString = "Banana"
	textString = "Give a minion +1/+1"
	isTargeted = true
	_Spell()

func _playSpell(target):
	target._WhenBananaIsPlayedOnSelf()
	target._giveStats(1, 1)
	queue_free()
	Input.set_custom_mouse_cursor(null)
